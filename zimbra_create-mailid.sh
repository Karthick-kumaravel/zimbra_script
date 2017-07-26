#!/bin/bash
display_name="all_users.txt"
USERS="users.txt"
for i in `cat $USERS`
do
displayName=$(grep $i $display_name | awk '{ print $2FS$3 }')
`zmprov ca $i 123456 displayName "$displayName" > results.txt`
for j in `cat results.txt`; do
echo "$j ----->  $i mail id created with displayName : $displayName"
done
done