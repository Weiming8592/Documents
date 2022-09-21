#!/bin/bash

#Create two new folder/directory in the Downloads and tmp directory to store the downloaded zip file and unzipped files 
date=$(date +%d_%m_%Y_%H:%M:%S)
mkdir -p /root/Downloads/${date}
mkdir -p /root/tmp/"Unzip"+${date}

#Download the zip file from the IP2Location website
cd tmp
wget -O ${date}.zip -q "https://www.ip2location.com/download?token=vzLavs4LYMDCSslndae9S9vblYJEn71hqKRq3clqVCjIBQdwn1UN4wOfF20f9ZKY&file=db3bin"
if [ ! -f ${date}.zip ]; then
        echo "Download failed."
	exit 0

elif [ ! -z "$(grep 'NO PERMISSION' ${date}.zip)" ]; then
        echo "Permission denied."
	exit 0

elif [ ! -z "$(grep '5 times' ${date}.zip)" ]; then
        echo "Download quota exceed."
	exit 0

elif [ $(wc -c < ${date}.zip) -lt 102400 ]; then
        echo "Download failed."
	exit 0
else
	echo "Download Successful"
fi

#Unzip the zip file in the tmp directory
unzip ${date}.zip -d /root/tmp/"Unzip"+${date}
if [ -z "$( find . -name 'IP-COUNTRY-REGION-CITY.BIN' )" ]; then
        echo "Unzip Failed"
	exit 0
else
	echo "Unzip Successful"
fi

#Copy the unzip BIN file into a folder in the Downloads directory 
cd "Unzip"+${date}/
cp IP-COUNTRY-REGION-CITY.BIN /root/Downloads/${date}
if [ -z "$( find . -name 'IP-COUNTRY-REGION-CITY.BIN' )" ]; then
        echo "Copy Failed"
        exit 0
else
        echo "Copy Successful"
fi

#Remove the zip file and unzip folder in the tmp directory
cd ../ 
rm -rf ${date}.zip "Unzip"+${date}
if [ -z "$( find . -name 'IP-COUNTRY-REGION-CITY.BIN' )" ]; then
        echo "Remove Successful"
else
        echo "Remove Failed"
	exit 0
fi 
