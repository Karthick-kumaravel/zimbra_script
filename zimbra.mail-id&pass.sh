#!/bin/bash
for i in `cat mail.voltech.txt | awk '{ print $1 }'`
do
	a=`cat mail.voltech.txt | grep -w $i | awk '{ print $2 }'`	
	`zmprov ca $i $a > result.txt`
	for j in `cat result.txt`	
	do
	echo "$j -----> $i Mail id created with the password $a" >> result.final.txt	
	echo "$j -----> $a Mail id created with the password $a"
done
done