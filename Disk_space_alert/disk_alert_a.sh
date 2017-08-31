################################################ Bash script to check the disk space ################################################

#!/bin/bash

> /tmp/result.txt
a=`df -hT | awk NR==5 | awk '{ print $6 }' | tr -d %`  # It's our wish to take the mount point's used space to comapre in 'if'loop #
HN=`hostname`

if [[ $a -ge 80 ]]; then                               # specify the alert level here, Here i use 80%  #
	echo "" > /tmp/result.txt
	echo "DISC Space Alert!!! from the srv - $HN" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
	echo "Below is the HDD Current status" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
	echo "`lsblk`" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
  echo "`df -hT`" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
  echo "Need to take the necessory action to get increase the HDD space in our server - $HN" >> /tmp/result.txt
	fi



Note: This script should be used along with "disk_alert_b.py" in the same folder to achive the result.
