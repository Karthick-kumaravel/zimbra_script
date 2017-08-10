#!/bin/bash

queue=`/opt/zimbra/postfix/sbin/postqueue -p | tail -1 | awk '{ print $5 }'`
q_stat=`/opt/zimbra/libexec/zmqstat`
HN=`hostname`

if [[ $queue -gt 100 ]]; then
	echo "" > /tmp/result.txt
	echo "Mailq Alert!!! from the srv - $HN" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
	echo -e "Curent Mails queue is : $queue" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
	echo "$q_stat" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
	echo "" >> /tmp/result.txt
	echo "Thank You" >> /tmp/result.txt
	echo "Regards" >> /tmp/result.txt
	echo "$HN" >> /tmp/result.txt
	echo "Subject: 	Number of mails on server $HN : $queue" | cat - /tmp/result.txt | /opt/zimbra/postfix/sbin/sendmail -F  "from-address" -t "to-address"
fi
