#!/bin/bash

file="$1"
filename=`basename $file`
currentdir=`pwd`
basedir=`dirname "$file"`
fileType=`file "$file"`
dosboxVer=`dosbox --version | perl -nle 'print $& if m{\d*\.\d*-\d}'`
if [ -f $currentdir/dosbox.conf ]; then
    dosBoxConfig=$currentdir/dosbox.conf
else
    dosBoxConfig=~/.dosbox/dosbox-$dosboxVer.conf
fi
dos="^(.*DOS.*)$"

echo $file

if [[ $fileType =~ $dos ]]; then
    cd $basedir
    dosbox -conf $dosBoxConfig -c "mount c: $basedir" -c c: -c $filename -c exit
    cd $currentdir
    exit
else 
    wine $1
    exit
fi

