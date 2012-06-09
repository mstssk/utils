#!/bin/bash

if [ -z `which ffmpeg` ]
then
	echo "This script needs 'ffmpeg' command!"
	exit
fi

if [ $# != 1 ]
then
	echo "Usage: extractaudio video.ext"
	exit
fi

input=$1
audiotype=`ffmpeg -i $input 2>&1 | grep Audio | sed -e "s/^.*Audio:\\s\(\\w\+\).*$/\1/"`
filename=`echo $input | sed -e "s/\.[^.]\+$//"`
output=$filename.$audiotype
echo "Extract from $input to $output"
if [ -e $output ]
then
	echo "File '$output' is already exists. Overwrite? [y/N] "
	read ans
	ans=`echo $ans | cut -c1 | tr '[A-Z]' '[a-z]'` # 1st char to lowercase
	if [ "$ans" != "y" ]
	then
		echo "Cancelled..."
		exit
	fi
fi

yes|ffmpeg -i $input -vn -acodec copy $filename.$audiotype 2> /dev/null
echo "Done!"



