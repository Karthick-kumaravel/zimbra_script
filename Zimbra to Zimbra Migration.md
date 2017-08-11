![](https://image.ibb.co/hgJMra/zimbra.jpg)

##  Requirement
##### Old server
- Need ssh root login
- Enough HDD space to store backups

##### New server
- Must be installed with latest stable zimbra
-  Need ssh root logins
- Enough HDD space to store backups

I have carried out this migration on Zimbra 8.6 (both old and new server) with cent os 6.9 (both old and new server)

## Presetup

Create a directory in both new and old server into which we store all required files and data for doing the migration

    [root@zimbra ~]# mkdir /backups/zmigrate
    [root@zimbra ~]# chown zimbra.zimbra /backups/zmigrate
    [root@zimbra ~]# su - zimbra


## Backup all data from Old server:

![](https://image.ibb.co/jOMVjv/zimbra2.jpg)


We are going to copy all data from old server without interrupting the services.

#### Find all domains
You need to find all the domains from your old server. We will store the domain list in a file called domains.txt. You need to back all the domains list as follows,

    zimbra@zimbra:~$ cd /backups/zmigrate
    zimbra@zimbra:/backups/zmigrate$ zmprov gad > domains.txt
    zimbra@zimbra:/backups/zmigrate$ cat domains.txt
    xyz.com
    abc.com
    
#### Find all admin accounts

Some servers have multiple admins. So it will be good to find all admin accounts. We will store the admins list in admins.txt

    zimbra@zimbra:/backups/zmigrate$ zmprov gaaa > admins.txt
    zimbra@zimbra:/backups/zmigrate$ cat admins.txt
    admin@abc.com
    
#### Find all email accounts

Get a list of your email accounts and save in the file emails.txt 

    zimbra@zimbra:/backups/zmigrate$ zmprov -l gaa >emails.txt
    
Please remove all the email accounts from the file /backups/zmigrate/emails.txt with a starting words like spam, virus, ham, galsync. These mailids are automatically created by zimbra, while installing zimbra.

#### Backup all user names , Display names and Given Names

We will create a directory called userdata/ which contains these details of each of those email accounts

    zimbra@zimbra:/backups/zmigrate$ mkdir userdata
    zimbra@zimbra:/backups/zmigrate$ for i in `cat emails.txt`; do zmprov ga $i  | grep -i Name: > userdata/$i.txt ; done
    
####  Find all email account’s passwords

Now need to find the encrypted password of all of your old email accounts and store it under a folder named userpass/ as follows:

    zimbra@zimbra:/backups/zmigrate$ mkdir userpass
    zimbra@zimbra:/backups/zmigrate$ for i in `cat emails.txt`; do zmprov  -l ga $i userPassword | grep userPassword: | awk '{ print $2}' > userpass/$i.shadow; done
    
####  Get all distribution lists

Now need to get all the distributions list,

    zimbra@zimbra:/backups/zmigrate$ zmprov gadl > distributinlist.txt
    
####  Get all members in distribution lists

Last Step we did a DL back up , Here we are doing back up the members in the DL
Create a directory called distributinlist_members
    
    zimbra@zimbra:/backups/zmigrate$ mkdir distributinlist_members
    zimbra@zimbra:/backups/zmigrate$ for i in `cat distributinlist.txt`; do zmprov gdlm $i > distributinlist_members/$i.txt ;echo "$i"; done
    
#### Now backup all email account

This process will take lot more time to complete, So be keep this step as last one.

    zimbra@zimbra:/backups/zmigrate$ for email in `cat emails.txt`; do  zmmailbox -z -m $i getRestURL '/?fmt=tgz' > $i.tgz ;  echo $email ; done
    
#### Copy the Details to new server

Copy the entire data in /backups/zmigrate (old server) to new server's /backups/zmigrate via scp or rsync


 ## Restore the data in new the server:
 
 ![](https://image.ibb.co/nwfvHF/zimbra3.jpg)
 
 #### Restore all domains
 Now create all the doamins by givin the below command
 
    zimbra@zimbra:/backups/zmigrate$ for i in `cat domains.txt `; do  zmprov cd $i zimbraAuthMech zimbra ;echo $i ;done
    
#### Create email accounts and set the old password

Create the  mail id with the same password and display name as in the old server.For this do Use the below script.

    #!/bin/bash
    USERPASS="/backups/zmigrate/userpass"
    USERDDATA="/backups/zmigrate/userdata"
    USERS="/backups/zmigrate/emails.txt"
    for i in `cat $USERS`
    do
    displayName=$(cat $USERDDATA/$i.txt | grep -i displayName | awk '{ print $2FS$3 }')
    shadowpass=$(cat $USERPASS/$i.shadow)
    temp_pass=CHANGEmeee12!
    zmprov ca $i $temp_pass displayName "$displayName" 
    zmprov ma $i userPassword "$shadowpass"
    done

#### Now recreate the distribution lists

Create all the DL

    zimbra@zimbra:/backups/zmigrate$ for i in `cat distributinlist.txt`; do zmprov cdl $i ; echo "$i -- done " ; done
    
#### Restore members to the distribution lists

Add to the respective users to the respective DL, Kindly use the below script to acive the same

    #!/bin/bash

    for i in `cat distributinlist.txt`
    do
	for j in `grep -v '#' distributinlist_members/$i.txt |grep '@'` 
	do
	zmprov adlm $i $j
	echo " $j member has been added to list $i"
	done

    done
    
####  Restore email accounts

Make this a last step as it take some more time to complete,

    zimbra@zimbra:/backups/zmigrate$for i in `cat emails.txt`; do zmmailbox -z -m $i postRestURL "/?fmt=tgz&resolve=skip" $i.tgz ;  ; echo "$i -- finished "; done


# Conclussion:
 
Thus a Zimbra to Zimbra Server migration completed.
