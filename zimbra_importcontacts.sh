#!/bin/bash
for i in `cat mailid.txt`
do
	a=$(ls contact/ | grep "$i")
	`zmmailbox -z -m $i pru /Contacts contact/$a`
	echo "Contact imported to $i"
done