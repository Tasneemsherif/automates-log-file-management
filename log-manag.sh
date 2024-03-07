#!/bin/bash

source_="/var/log"
dest="/var/log/new_"

cd "$source_"
sudo cp wtmp new_
if test -e new_; then
	echo "File Copied"
else 
	echo "unable to copy"
fi
echo "" > new_file
if test -s new_file; then
	echo "Deleted Successfully"
else 
	echo "unable to delete"
fi


