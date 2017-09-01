########################################################    Email the Disk Alert    #########################################################

#!/usr/bin/python

import os
import smtplib

os.system("./disk_alert_a.sh")                        	   # Bash script to check the disk space (the script is in the same folder)                                   

a=os.stat('/tmp/result.txt').st_size==0

if ( a == False ):

	TO = 'name@domain.com'                              # To email-address
	BCC = 'name@domain.com'				    # Bcc email address
	SUBJECT = '##### Disk Space Alert...!!!!#####'      # Subject of the email
	
	f = open('/tmp/result.txt', 'r')                    # '/tmp/result.txt' is the file contains the output of the script-disk_alert_a.sh
	TEXT = f.read()
	f.close()
	
	
	sender = 'name@domain.com'                          # Sender email-address
	passwd = 'Password'                                 # Sender email-address's password

	server = smtplib.SMTP('smtp.domain.com', 587)       # SMTP of the server
	server.ehlo()                                       # ESMTP
	server.starttls()                                   # TLS
	server.ehlo()
	server.login(sender, passwd)
	
	
	BODY = '\r\n'.join([
        	'To: %s' % TO,
		'From: %s' % sender,
		'subject: %s' % SUBJECT,
		'',
		TEXT
		])
	try:
		server.sendmail(sender, [TO, BCC], BODY)
		print 'email sent'
        except:
                print 'error'


Note: This script should be used along with "disk_alert_a.sh" in the same folder to achive the result.
