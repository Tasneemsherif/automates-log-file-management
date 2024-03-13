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
report_dir="/var/log/reports"
timestamp=$(date +"%Y%m%d_%H%M%S")
report_file="${report_dir}/report.${timestamp}.txt"

#sudo cp wtmp new_

sudo mkdir  "$report_dir"
sudo mkdir  "$backup_dir"


sudo cp "$backup_2" "$log"
sudo cp "$log" "$backup_2"
sudo cp "$backup_2" "$log"

if [ ! -w "$report_dir" ]; then
	echo "adjut permissions"
	sudo chmod u+w "$report_dir"
fi

analyze_log() {

        local file=$1
        local report=$2

        sudo echo "log report - generated on $(date)" > "$report"
        sudo echo "============" >> "$report"

        sudo echo "Error Count:" >> "$report"
        sudo grep -i "error" "$file" | wc -l >> "$report"

        sudo echo "warning counts:" >> "$report"
        sudo grep -i "critical" "$file" >> "$report"

        echo "Report saved"

}

if test -e "$log" ; then
	#echo "File Copied"
        # generate a timestamp for current backup
	timestamp=$(date +"%Y%m%d_%H%M%S")
	backup_file="${backup_dir}/messages.${timestamp}"
	sudo cp "$log" "$backup_file"
	echo "Backup created"
        sudo rm "$log"
	echo "Content of $log cleared"
        
	ls -tp "${backup_dir}" | grep -v '/$' | tail -n +$((max_backups + 1)) | xargs -I {} rm -- {}
        echo "old backups removed, retaining only the last $max_backups backups."

        analyze_log "$backup_file" "$report_file"

else 
	echo "log file dosen't exist"
fi


