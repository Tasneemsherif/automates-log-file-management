#!/bin/bash
# 
# read -p "Enter your name: " name
# 
# read -p "Enter your age: " age
# 
# re='^[0-9]+$'
# if ! [[ $age =~ $re ]]; then
# 	echo "Error: not a number"; exit 1
# fi
# 
# if ((age < 0 || age > 100)); then
# 	echo "Error: Age must be between 1 and 100"; exit 1
# fi
# 
# read -p "Enter your country: " country
# 
# echo "Name: $name" >> user_info.log
# echo "Age: $age" >> user_info.log
# echo "Country: $country" >> user_info.log
# echo "your details logged"

log="/var/log/vmware-vmsvc-root.log"
backup_dir="/var/log/backups"
max_backups=3
backup_2="/var/log/newfile"

#sudo cp wtmp new_

sudo mkdir -p "$backup_dir"
sudo cp "$backup_2" "$log"
sudo cp "$log" "$backup_2"
sudo cp "$backup_2" "$log"

if test -e "$log" ; then
	#echo "File Copied"
# generate a timestamp for current backup
	timestamp=$(date +"%Y%m%d_%H%M%S")
	backup_file="${backup_dir}.${timestamp}"
	sudo cp "$log" "$backup_file"
	echo "Backup created"
        sudo rm "$log"
	echo "Content of $log cleared"
        
	ls -tp "${backup_dir}" | grep -v '/$' | tail -n +$((max_backups + 1)) | xargs -I {} rm -- {}
        echo "old backups removed, retaining only the last $max_backups backups."




else 
	echo "log file dosen't exist"
fi


