#!/bin/bash
all_accounts=`zmprov -l gaa | grep "sixthstar.in"` 
for account in $all_accounts
do
mbox_size=`zmmailbox -z -m $account gms`
echo "Mailbox size of $account = $mbox_size" > results.txt
echo "Mailbox size of $account = $mbox_size" >> final.txt
echo "Mailbox size of $account = $mbox_size"
a=`cat results.txt | awk '{ print $7 }'`
if [[ $a == B ]]; 
	then
	b=`cat results.txt | awk '{ print $6 }'`
	`calc() { awk "BEGIN{print $*}"; } ; calc $b/1024/1024/1024 >> num.txt`
elif [[ $a == KB ]]; 
	then
	c=`cat results.txt | awk '{ print $6 }'`
	`calc() { awk "BEGIN{print $*}"; } ; calc $c/1024/1024 >> num.txt`
elif [[ $a == MB ]]; 
	then
	d=`cat results.txt | awk '{ print $6 }'`
	`calc() { awk "BEGIN{print $*}"; } ; calc $d/1024 >> num.txt`
elif [[ $a == GB ]];
	then
	`cat results.txt | awk '{ print $6 }' >> num.txt`
fi  
done

sum=0
for i in `cat num.txt`
do
	sum=`calc() { awk "BEGIN{print $*}"; } ; calc $sum+$i`
done
    e=`cat results.txt | awk '{ print $4 }' | awk -F@ '{ print $2 }'`
    f=$(echo -e "\033[32mTotal size of the domain "$e" is $sum GB\033[0m")
    echo ""
    echo $f >> final.txt
	echo $f    
    echo ""
    exit 0 