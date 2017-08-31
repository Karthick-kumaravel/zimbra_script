#!/bin/bash

ip=`ip addr|awk '/ens33/ && /inet/ {gsub(/\/[0-9][0-9]/,""); print $2}'`  # To get specific ip of server. With interface ens33
mail_user=support@xyz.in,client@xyz.com                                   # To sendmail, support and client.  
HN=`hostname`
disk=`df -hT | grep -w /|awk '{print $6}'`                                # Here, i grep (/) root partition and it will display used percentage    
diskrem=`df -hT | grep -w /|awk '{print $4}'`                           # Here, i used to get remaining space
df=`df -hT | grep -w /|awk '{print $6}'|tr -d %`

if [[ $df > 40 ]];                                                      
	then
	Head=`echo "Dear Sir,">>result.txt`
		space2=`echo "">>result.txt`
	body=`echo "In our $HN server IP  ($ip) our disk space has been reached $disk from overall disk space of our $HN only $diskrem Space remaining So kindly take a priority on this notification and do the needful for deleting unwanted files or accounts from our server, to prevent service interruption.">>result.txt`
		space3=`echo "">>result.txt`
		space4=`echo "">>result.txt`
		space16=`echo "root partition usage">>result.txt`
		space17=`echo "====================">>result.txt`
	a=`df -hT | grep -w / >> result.txt`
		space23=`echo "">>result.txt`
		space26=`echo "Overall Disk usage">>result.txt`
                space25=`echo "====================">>result.txt`
		d=`df -hT >> result.txt`		
		space5=`echo "">>result.txt`
		space6=`echo "">>result.txt`
		space11=`echo "Hard Disk connected">>result.txt`
		space12=`echo "===================">>result.txt`		
		d=`lsblk | grep sd* >> result.txt`
	results=result.txt
		space7=`echo "">>result.txt`
	aa=`echo "Support team,">>result.txt`
		space30=`echo "_____________________">>result.txt`
	space21=`echo "">>result.txt`
		space8=`echo "">>result.txt`
		space9=`echo "">>result.txt`

	/usr/bin/mail -s "***Disk Space warning*** $HN : $ip" -r "Disk_Space_alert!!<root@srv.hostname.com>" $mail_user < $results

> result.txt
fi
exit 0

