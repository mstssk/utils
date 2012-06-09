#!/bin/bash

if [ -z `which swfextract` ]
then
	echo "This script needs 'swfextract' command!"
	echo "You must install 'swftools' package."
	exit
fi

if [ $# != 1 ]
then
	echo "Usage: swfextractall foo.swf"
	exit
fi

input=$1

# Ensure output directory.
dir="$1".output
if [ -e $dir ]
then
	echo "Output into '$dir/'"
else
	echo "Make output dirctory: '$dir/'"
	mkdir $dir
fi

# Print screan output of swfextract command as a escription.
swfextract $input > $dir/files.txt

swfextract $input | while read line
do
	if [[ "$line" =~ \[\-[a-z]\] ]]
	then
		opt=`echo $line | sed -e "s/\s\+\?\[//"`
		opt=`echo $opt | sed -e "s/\].\+//"`
		arr=( `echo $line | tr -s ',' ' '` )
		echo ${arr[1]} ${arr[2]} ${arr[3]} ${arr[4]}
		for (( i = 4; i < ${#arr[*]}; i++ ))
		do
			# Split arguments and 2nd loop. Numbers format: "3-6"
			numrange=${arr[i]}
			start=`echo $numrange | sed -e "s/-.\+//"`
			end=`echo $numrange | sed -e "s/.\+-//"`
			for (( num = $start; num <= $end; num++ ))
			do
				swfextract $input $opt $num -o $dir/$num -P
			done
		done
	fi
done

echo "done!"

