#!/bin/bash

read -p "Enter your name: " name

read -p "Enter your age: " age

re='^[0-9]+$'
if ! [[ $age =~ $re ]]; then
	echo "Error: not a number"; exit 1
fi

if ((age < 0 || age > 100)); then
	echo "Error: Age must be between 1 and 100"; exit 1
fi

read -p "Enter your country: " country

echo "Name: $name" >> user_info.log
echo "Age: $age" >> user_info.log
echo "Country: $country" >> user_info.log
echo "your details logged"

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


