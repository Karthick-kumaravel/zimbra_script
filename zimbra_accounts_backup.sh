# Email notification options
EMAILFROM="Specify the from address"
EMAILTO="Specify the to address"
 
# Email account NOT to backup
EXCEPTIONS="specify the Email account NOT to backup , with comma(,) as a seperator"
 
# Paths and file defs, probably nothing for you to change
TEMPDIR="/mnt/mailbackup"
LOGFILE="${TEMPDIR}/zm-user-backup.log"
SOURCEDIR="/opt/zimbra"
TARGETDIR="${TEMPDIR}/zmusers"
ARCHIVEFILE="`date +%Y-%m-%d_%H-%M`_zmusers.tar"
MAILFILE="${TEMPDIR}/zm-user-backup-mail.$$"
MAILLOG="${TEMPDIR}/zm-user-backup-mail-log.$$"
FTPLOG="${TEMPDIR}/zm-user-backup-ftp-log.$$"
 
 
 
# Nothing to change here, move along
HOSTNAME=$(hostname -f)
SCRIPTNAME=${0}
RETURNVALUE=0
UCOUNT=0
ERRORFLAG=0
 
#######################################
##            FUNCTIONS              ##
#######################################
 
function f_sendmail()
{
  # Purpose: Send email message.
  # Parameter #1 = Subject
  # Parameter #2 = Body
  echo "From: ${EMAILFROM}" > ${MAILFILE}
  echo "To: ${EMAILTO}" >> ${MAILFILE}
  echo "Subject: ${1}" >> ${MAILFILE}
  echo "" >> ${MAILFILE}
  echo ${2} >> ${MAILFILE}
  echo "" >> ${MAILFILE}
  cat ${MAILLOG} >> ${MAILFILE}
  echo "" >> ${MAILFILE}
  cat ${FTPLOG} >> ${MAILFILE}
  echo "" >> ${MAILFILE}
  echo "Server: ${HOSTNAME}, Program: ${SCRIPTNAME}" >> ${MAILFILE}
  ${SOURCEDIR}/postfix/sbin/sendmail -t < ${MAILFILE}
}
 
function f_cleanup()
{
  rm ${MAILFILE}
  rm ${MAILLOG}
  rm ${FTPLOG}
  # Remove backup's older then 5 days
  find ${TEMPDIR}/*.tar -mtime +5 -exec rm {} \;
}
 
function f_log()
{
  # Handles logging of messages
  # Parameter #1 = Log Message
  STAMP=`date '+%Y-%m-%d %H:%M:%S'`
  echo "${STAMP} ${1}"
  echo "${STAMP} ${1}" >> ${LOGFILE}
  echo "${STAMP} ${1}" >> ${MAILLOG}
}
 
 
#######################################
##           MAIN PROGRAM            ##
#######################################


echo "---------------------------------------------------" >> ${LOGFILE}
f_log "- zm user backup started."
if [ -d "${TARGETDIR}" ]; then
  # Purge existing archives.
  rm ${TARGETDIR}/*.tgz 1>/dev/null 2>&1
else
  # Make the folder if it does not exist.
  mkdir -p ${TARGETDIR} 1>/dev/null 2>&1
fi
f_log "-- Getting list of user accounts"
for ACCT in `su - zimbra -c "zmprov -l gaa"`
do
  # Check to see if current account should be skipped.
  if echo "${EXCEPTIONS}" | grep -q ${ACCT}
  then
    # Exception found, skip this account.
    echo "" > /dev/null
  else
    # Backup user account.
    UCOUNT=$((UCOUNT+1))
    f_log "--- Backing up user ${ACCT}"
    ${SOURCEDIR}/bin/zmmailbox -z -m ${ACCT} getRestURL "//?fmt=tgz" > ${TARGETDIR}/${ACCT}.tgz
    RETURNVALUE=$?
    if [ ! ${RETURNVALUE} -eq 0 ]; then
      # Something went wrong.
      f_log "---- Error on ${ACCT}, exit code ${RETURNVALUE}"
      ERRORFLAG=$((ERRORFLAG+1))
    fi
  fi
done
f_log "-- ${UCOUNT} accounts processed."
 
# Comment out the below line if you do not want to receive statistic emails.
#f_sendmail "Zimbra User Mailbox Backup" "${UCOUNT} accounts backed up."
 
f_log "--- Setting file permissions on ${TARGETDIR}/*.tgz"
chmod 0600 ${TARGETDIR}/*.tgz
f_log "--- Creating a single archive ${TEMPDIR}/${ARCHIVEFILE}"
tar -cf ${TEMPDIR}/${ARCHIVEFILE} ${TARGETDIR} 1>/dev/null 2>&1
RETURNVALUE=$?
if [ ! "${RETURNVALUE}" -eq "0" ]; then
  # Something went wrong.
  f_log "--- Error creating ${TEMPDIR}/${ARCHIVEFILE}, Return Value: ${RETURNVALUE}"
  ERRORFLAG=$((ERRORFLAG+1))
fi
rm -rf /mnt/mailbackup/zmusers
/opt/zimbra/postfix/sbin/sendmail -t "Backup Completed" "To Mail id"<$LOGFILE
