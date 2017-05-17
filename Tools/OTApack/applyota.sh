#!/bin/bash

##
# applyOTA - A simple shell script to emulate what installd would do
# for an OTA, by recreating the entire filesystem of an iOS device based 
# on an OTA update
#
# For more details, q.v. http://NewOSXBook.com/articles/OTA.html
#
# Jonathan Levin, J@ ...... From "Mac OS X/iOS Internals, 2nd Edition"
# 
# Notes:
# ------
# I'm doing this as a shell script because I want to open source it anyway,
# and it's a faster implementation than doing it in code, what more it depends
# on external programs. I know - It's not as fast, granted, but you're probably 
# going to want to use this once per OTA.
#
# This can probably be optimized. Or written in Perl, or Python. I abhor both.
# 
# I welcome your input. Use the NewOSXBook website forum if you have any notes, 
# comments, requests, what not. If you find this useful, a nice word or two 
# would be appreciated :)
#
#
# Prereqs:
#
# bxpatch
# ota - from above link. Put in your directory.
#
# You really want to install your ssh key on the iOS device's ~/.ssh/authorized_keys,
# unless you're ready to be pummelled by SSH prompts.
# 
#
##

OTA=./otaa
BXPATCH=./bxpatch
DEFIOSDEV=root@phontifex-2
DEFIOSPORT=2222

UNPACKED_OTA_DIR=~/Downloads/OTA

umask 022

if [[ $# -lt 1 ]]; then

	echo Usage: $0 file/dir 
	echo Where: file/dir is the patch to apply
	echo 
	echo Be sure to set IOSDEV and IOSPORT first if the defaults \($DEFIOSDEV, $DEVIOSPORT\) aren\'t ok
        echo and you might want to deploy your ssh key on the device.
	exit 1
fi

function single_file_case() {
	# echo Single file mode for $1
	bn=`basename $1`
	dn=`dirname $1`
	if [[ $bn == $1  || $bn == ./$1 ]]; then
		echo ignoring this
	else
	echo Retrieving $bn from your device...
	mkdir -p ./$dn
	scp -P ${DEFIOSPORT} ${DEFIOSDEV}:/$1 ./$dn/$bn.pre || ( echo "Error retrieving file from device" && exit 2 )
	chmod 644 ./$dn/$bn.pre 
	echo Patching $1 with patch from ${UNPACKED_OTA_DIR}/AssetData/payloadv2/patches/$1 
	cp ${UNPACKED_OTA_DIR}/AssetData/payloadv2/patches/$1 ./$1.patch
	$BXPATCH ./$dn/$bn.pre ./$dn/$bn.tmp ./$1.patch > /dev/null
	mv ./$dn/$bn.tmp ./$dn/$bn
	rm ./$dn/$bn.pre ./$1.patch
	fi  # bn == $1

}

doneDir=0
function directory_case() {
	if [[ -d ${UNPACKED_OTA_DIR}/AssetData/payloadv2/patches/$1 ]]; then
	# directory mode
	doneDir=1
	echo Directory mode $1
	for f in  ${UNPACKED_OTA_DIR}/AssetData/payloadv2/patches/$1/*; do
	     if [ -f $f ]; then
		# Do the single file mode 
		bn=`basename $f`
		single_file_case $1/$bn
	      fi
	     if [ -d $f ]; then
		# Do the directory case
		echo recursing $f
		bn=`basename $f`
		directory_case $1/$bn
	     fi
	done
	fi



} 

if [[ -f ${UNPACKED_OTA_DIR}/AssetData/payloadv2/patches/$1 ]]; then
	# single file mode

	single_file_case $1

	exit 0
fi

# Try directory case anyway

directory_case $1


if [[ $doneDir == 1 ]]; then
    exit 0
fi

# if neither, the argument wasn't found..

echo Requested file/dir $1 not found\!






