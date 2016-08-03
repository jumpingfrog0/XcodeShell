#!/bin/bash

#------------------------------------
# Function: Automated packaging, build Xcode project or workspace, archive it and export ipa file. You can run the command `man xcodebuild` to see more.
#
# Usage: Copy the export options plist files and this `ipa-build.sh` script into the root path of xcode project or workspace, type in your Certificates and Profiles in line 51 - 58, and then run it.
#   If the terminal tip `Permision denied`, run the command `sudo chmod +x ipa-build.sh`.
#  
# Author: jumpingfrog0 ( 黄东鸿 ）
# Email:  jumpingfrog0@gmail.com
#         447467113@qq.com
#
# Create Date: 2016/06/27
#
#------------------------------------

#--------------- Help ---------------
# Options: 
# 	-D : Build with development certificate for debug
# 	-T : Build with Ad-hoc certificate for testing
# 	-P : Build with production certificate for AppStore
#   -E : Build with enterprise certificate for in-house
# 	-w : Build xcode workspace
# 	-c : Build xcode project
# 	-n : Cleans the build directory before compling
# 
# Configuration plists:
#	(You can edit thoese to meet the requirements, run the command `xcodebuild --help` to see more.)
#
#	DevExportOptions.plist : The plist file that configures archive exporting for development
#	AdHocExportOptions.plist : The plist file that configures archive exporting for Ad-hoc
#	AppStoreExportOptions.plist : The plist file that configures archive exporting for App Store
#	EnterpriseExportOptions.plist : The plist file that configures archive exporting for In-house
#
# Output:
# 	archive : The path of files archived
#	export  : The path of ipa files exported
#	ipa-build.log : The log file
#	build_cmd.sh  : The command script
#
# Example: 
#	./ipa-build.sh -P -w -n
#   Build Xcode workspace with production certificate for AppStore, clean it before compling.
#
# Error: 
# 	If archive failed or export failed, you can see the log in `ipa-build.log`.
#
#------------------------------------

# Type in your Certificates and Profiles here
CODE_SIGN_IDENTITY_DEVELOPMENT="iPhone Developer: xxxx (xxxx)" 	# Development Certificate
CODE_SIGN_IDENTITY_DISTRIBUTION="iPhone Distribution: XXX, Ltd. (xxxxxxxxxx)" # Distirbution Certificate
# If you don't have company certificate, use personal certificate
# CODE_SIGN_IDENTITY_DISTRIBUTION="iPhone Developer: xxxx (xxxx)"

PROVISIONING_PROFILE_DEVELOP="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
PROVISIONING_PROFILE_ADHOC="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
PROVISIONING_PROFILE_PRODUCTION="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
PROVISIONING_PROFILE_ENTERPRISE="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"


# export options plist
DEV_EXPORT_OPTIONS="./DevExportOptions.plist"
ADHOC_EXPORT_OPTIONS="./AdHocExportOptions.plist"
APPSTORE_EXPORT_OPTIONS="./AppStoreExportOptions.plist"
ENTERPRISE_EXPORT_OPTIONS="./EnterpriseExportOptions.plist"


# build configuration
build_config="Release"
project_path=$(pwd)
log_path="ipa-build.log"
build_path=${project_path}/build
should_clean='n'

# Get app version information
function GetVersionInfo() {
	project_name=$1
	app_info_plist_path="${project_path}/${project_name}/Info.plist"
	app_version=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${app_info_plist_path})
	app_build_version=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${app_info_plist_path})
}

# archive project or workspace
function Archive() {

	# clean
	if [ ${should_clean} = 'y' ]; then
		echo "Cleaning ..."
		echo "===================== `Date` CLEAN BEGIN =====================" >> ${log_path}
		xcodebuild clean -configuration ${build_config} >> ${log_path}
		echo -e "===================== `Date` CLEAN END ===================== \n\n" >> ${log_path}
		echo " ** CLEAN SUCCEEDED ** "
	fi

	# combine build command
	build_cmd='xcodebuild'

	if [ ${is_workspace} == 1 ];then # archive xcode project

		build_cmd="${build_cmd} -project ${build_xcodeproj} -scheme ${build_scheme} -configuration ${build_config} \
		archive -archivePath ${archive_path} \
		CODE_SIGN_IDENTITY=\"${CODE_SIGN_IDENTITY}\" \
		PROVISIONING_PROFILE=\"${PROVISIONING_PROFILE}\" >> ${log_path}"

	else # archive xcode workspace

		build_cmd="${build_cmd} -workspace ${build_workspace} -scheme ${build_scheme} -configuration ${build_config} \
		archive -archivePath ${archive_path} \
		CODE_SIGN_IDENTITY=\"${CODE_SIGN_IDENTITY}\" \
		PROVISIONING_PROFILE=\"${PROVISIONING_PROFILE}\" >> ${log_path}"
	fi

	# run command
	# I don't known why if running `build_cmd` command directly, it throw an error `xcodebuild: error: Unknown build action 'Developer:'.` 
	# But I write `build_cmd` to a bash script file and then run it, it amazing work fine. I was in a mess.
	$(cd ${project_path})
	echo $build_cmd
	echo $build_cmd > build_cmd.sh
	echo "===================== `Date` ARCHIVE BEGIN =====================" >> ${log_path}
	echo "Archiving ..."

	# ${build_cmd}
	. build_cmd.sh

	if [ $? -eq 0 ]; then # archive succeeded

			echo "** ARCHIVE SUCCEEDED **"
			echo -e "===================== `Date` ARCHIVE END ===================== \n\n" >> ${log_path}

			Export
	else # archive failed
		echo "** ARCHIVE FAILED **"
		echo -e "===================== `Date` ARCHIVE END ===================== \n\n" >> ${log_path}
	fi
}

# export the ipa file
function Export() {
	# combine export command
	export_cmd='xcodebuild'
	export_cmd="${export_cmd} -exportArchive -archivePath ${archive_path} \
	-exportOptionsPlist ${export_options}\
	-exportPath ${export_path} >> ${log_path}"

	#run command
	echo $export_cmd
	echo $export_cmd > export_cmd.sh
	echo "===================== `Date` EXPORT BEGIN =====================" >> ${log_path}
	echo "Exporting ..."
	# $(${export_cmd})
	. export_cmd.sh

	if [ $? -eq 0 ]; then
		echo " ** EXPORT SUCCEEDED **"
	else
		echo " ** EXPORT FAILED **"
	fi

	echo -e "===================== `Date` EXPORT END ===================== \n\n" >> ${log_path}
}


if [ $# -lt 2 ]; then
	echo "Error! Should enter at least two params. (e.g. ipa-build -w -D)"
	exit 2
fi

param_pattern="DTPEwnco:"
while getopts $param_pattern optname
	do
		case "$optname" in
			"D")
				CODE_SIGN_IDENTITY=${CODE_SIGN_IDENTITY_DEVELOPMENT}
				PROVISIONING_PROFILE=${PROVISIONING_PROFILE_DEVELOP}
				export_options=${DEV_EXPORT_OPTIONS}
				;;
			"T")
				CODE_SIGN_IDENTITY=${CODE_SIGN_IDENTITY_DISTRIBUTION}
				PROVISIONING_PROFILE=${PROVISIONING_PROFILE_ADHOC}
				export_options=${ADHOC_EXPORT_OPTIONS}
				;;
			"P")
				CODE_SIGN_IDENTITY=${CODE_SIGN_IDENTITY_DISTRIBUTION}
				PROVISIONING_PROFILE=${PROVISIONING_PROFILE_PRODUCTION}
				export_options=${APPSTORE_EXPORT_OPTIONS}
				;;
			"E")
				CODE_SIGN_IDENTITY=${CODE_SIGN_IDENTITY_DISTRIBUTION}
				PROVISIONING_PROFILE=${PROVISIONING_PROFILE_ENTERPRISE}
				export_options=${ENTERPRISE_EXPORT_OPTIONS}
				;;
			"w")
				is_workspace=0
				workspace_name='*.xcworkspace'
				build_workspace=$(basename $project_path/${workspace_name})
				build_scheme=$(basename $build_workspace .xcworkspace)
				;;
			"c")
				is_workspace=1
				xcodeproj_name='*.xcodeproj'
				build_xcodeproj=$(basename $project_path/${xcodeproj_name})
				build_scheme=$(basename $build_xcodeproj .xcodeproj)
				;;
			"o")
				echo "o"
				echo $OPTIND
				;;
			"n")
				should_clean='y'
				;;
			?)
				echo "Error! Unknown option.Usage: args [-D | -T | -P -E][-w | -c | -n | -o PATH]"
				exit 2
				;;
			":")
				echo "Error! No argument value for option $OPTARG"
				exit 2
				;;
			*)
				echo "Error! Unknown error while processing options"
				exit 2
				;;
		esac
	done
	
# configurate path
GetVersionInfo "${build_scheme}"
archive_path="./archive/${build_scheme}-${app_version}-$(date "+%G-%m-%d.%H-%M-%S")/${build_scheme}.xcarchive"
export_path="./export/${build_scheme}-${app_version}-$(date "+%G-%m-%d.%H-%M-%S")"

# run archive command
Archive

# remove tmp file
# $(rm build_cmd.sh)
# $(rm export_cmd.sh)

