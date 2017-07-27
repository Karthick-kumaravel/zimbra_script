#!/bin/bash
mailid=`zmprov gqu server.domain.com | awk '{ print $1 }'`
for i in $mailid ;
do
    max_quota=`zmprov gqu server.domain.com | grep $i | awk '{ print $2 }'`
    used_quota=`zmprov gqu server.domain.com | grep $i | awk '{ print $3 }'`
    if [ $max_quota != 0 ]
        then
        per=`echo $used_quota*100/$max_quota | bc`
        if [ $per -ge 25 ]; 
        	then
        	echo "\033[31m\033[1m$i used $per% of alloted disc quota\033[0m" 
        	echo "$i used $per% of alloted disc quota" >> results.txt
        else
        	echo "$i used $per% of alloted disc quota"        	
        fi
    else
    	echo "$i having unlimitted quota"
    fi
done
