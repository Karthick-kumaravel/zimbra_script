#!/bin/sh

for account in `zmprov -l gaa`; 
do

forwardingto=`zmprov ga $account |grep 'zimbraPrefMailForwardingAddress' | awk '{print $2}'`

if [ "$forwardingto" != "" ]; then
echo "$account is forwarded to $forwardingto"
else
echo "$account is not forwarded"
fi
done
