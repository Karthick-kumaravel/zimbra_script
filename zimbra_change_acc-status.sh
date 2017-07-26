#!/bin/bash
for i in `cat locked.txt`
do
`zmprov ma $i zimbraAccountStatus locked`
echo "$i account closed" >> results.txt
done
exit 0
