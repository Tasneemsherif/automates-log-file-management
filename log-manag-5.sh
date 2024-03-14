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
config_file=""
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

show_help(){
	echo "uasage: $0 [options]"
	echo "options:"
	echo " -l <log_file>"
	echo " -b <backup_file>"
	echo " -r <report_fiel>"
	echo " -m <max_backups>"
	echo " -c <config_file>"
	echo " -h "
}

while getopts ":l:b:r:m:c:h" opt; do
	case ${opt} in
		l ) log_file=$OPTARG ;;
		b ) backup_dir=$OPTARG ;;
		r ) report_dir=$OPTARG ;;
		m ) max_backups=$OPTARG ;;
		c ) config_file=$OPTARG ;;
		h ) show_help
		    exit 0 ;;
		\? ) echo "invalid option" 1>&2
		     show_help
		     exit 1 ;;
	esac
done


if [[ -f "$config_file" ]]; then
	while IFS='=' read -r key value; do
		case "$key" in 
			'log_file') log_file=$value ;;
			'backup_dir') backup_dir=$value ;;
			'report_dir') report_dir=$value ;;
			'max_backups') max_backups=$value ;;
		esac
	done < "$config_file"
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
        
#	ls -tp "${backup_dir}/messages" | grep -v '/$' | tail -n +$((max_backups + 1)) | xargs -I {} rm -- {}
 #       echo "old backups removed, retaining only the last $max_backups backups."

  #      analyze_log "$backup_file" "$report_file"

else 
	echo "log file dosen't exist"
fi


