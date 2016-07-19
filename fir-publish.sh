#!/bin/bash

#------------------------------------
# Function: Publish Application on fir.im
#
# Usage: Run command `gem install fir-cli` to install `fir-cli` tool first, copy this `fir-publish.sh` script into the root path of xcode project or workspace, type in The API Token of `fir.im`, and then run this script after `ipa-build.sh` script.
#
# See more : https://github.com/FIRHQ/fir-cli
#  
# Author: jumpingfrog0 ( 黄东鸿 ）
# Email:  jumpingfrog0@gmail.com
#         447467113@qq.com
#
# Create Date: 2016/06/27
#
#------------------------------------


# Type in API Token here
# Get API Token from "http://fir.im/apps/apitoken"
API_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

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

echo 'Login Fir.im ...'
fir login ${API_TOKEN}

if [ $? == 0 ]; then

	CheckIpaExist

	echo "fir publish ${ipa_file} -Q --no-open"

	fir publish ${ipa_file} -Q --no-open

else
	echo 'Log in Fir.im failed.'
fi

