#!/bin/bash

#------------------------------------
# Function: Publish Application to pgyer.
#
# Usage: Run command `brew install jq` to install `jq` first, copy this `fir-publish.sh` script into the root path of xcode project or workspace, type in the user key and api key of `pyger`, and then run this script after `ipa-build.sh` script.
#
# See more : https://www.pgyer.com/doc/view/upload_one_command
#  
# Author: jumpingfrog0 ( 黄东鸿 ）
# Email:  jumpingfrog0@gmail.com
#         447467113@qq.com
#
# Create Date: 2016/06/27
#
#------------------------------------


# Type in user key and api key here
# Get user key and api key seeing "https://www.pgyer.com/doc/view/upload_one_command"
user_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
api_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Check the ipa file whether exists
function CheckIpaExist() {

	# enter `export` directory
	cd export
	if [ $? != '0' ]; then
		echo "Error! No export directory exists. Please run the \"ipa-build\" shell script first."
		exit 1
	fi

	# try to get the sub-directory that included ipa file and check it whether exists
	latest_ipa_directory=`ls -l | tail -n 1 | awk '{print $9}'`

	if [ ! -d "${latest_ipa_directory}" ]; then
		echo "Error! No ipa directory exists. Please run the \"ipa-build\" shell script first."
		exit 1
	fi

	# enter sub-directory and check ipa file whether exists
	cd ${latest_ipa_directory}
	ipa_file=`ls | grep *.ipa`

	if [ ! -f "${ipa_file}" ]; then
		echo "Error! No ipa file exists. Please run the \"ipa-build\" shell script first."
		exit 1
	fi
}

CheckIpaExist

cmd="curl -F \"file=@${ipa_file}\" \
-F \"uKey=${user_key}\" \
-F \"_api_key=${api_key}\" \
https://www.pgyer.com/apiv1/app/upload"

echo ${cmd}
echo 'Publishing to pgyer ...'
eval $cmd > pgyer.log

echo $(cat pgyer.log)
result=$(cat pgyer.log | jq '.code')

if [ $result == 0 ]; then
	echo -e "\n ** PUBLISH TO PGYER SUCCEEDED **"
else
	echo -e "\n ** PUBLISH TO PGYER FAILED ** "
fi