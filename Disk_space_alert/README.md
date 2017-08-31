



# Disk Space Alert (In Linux server)

This "Disk_space_alert folder" is having two script files namely, **disk_alert_a.sh and disk_alert_b.py**
#

 ### disk_alert_a.sh :
 
 This is the **Bash script** which checks for the disck space.
 
 If the disk space reaches the specified limit (i take 80% in the script), the 'if statement' get execute and saves the standard output in the file - /tmp/result.txt
 
 Here is the job over for this bash script.
 
 
 ### disk_alert_b.py:
 
 This is the **Python script** which send email the disk alert to the sepicified email-id.
 
 We can also use the **Sendmail** feature in the bash script to send the email, The difficulty is, while sending mail through bash script the email is not sending from the proper/valied sender in the server, because of this issue our email may get blocked by the recepient's server or the gateway.

To get over come this issue i am going for python to send email.

 ### Execution:
 
 Execute the script as below,
 
    $python disk_alert_b.py

On executing the above command, It will **check for the disk space** and if the disk space exceeds the specified limit it will send the disk space alert email to the specified sender.

Place the above command in the **cronjob** to get check the disk space periodically.

    $ crontab -e
      0   10  *   *   0-6     <path/disk_alert_b.py>

The above **cronjob** will execute the script (disk_alert_b.py) daily at 10:00 am.

Thats it, we have sucessfully implemented **Disksapce Alert** in our server 


**Thank You !!!**   

 
