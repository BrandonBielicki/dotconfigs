#! /bin/bash

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE=$SRCDIR/../logs/log
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> $LOGFILE
echo "  Entered $0" >> $LOGFILE
USER=$1
HOMEDIR="$(eval echo ~$USER)"
echo "  Running as user $USER" >> $LOGFILE
echo "  $USER's home directory: $HOMEDIR" >> $LOGFILE


cd $SRCDIR/../files
su $USER --session-command "cp -R . $HOMEDIR/"

if [ $? = 0 ]; then
    cd $SRCDIR
    touch ../work/dotconfig
    #echo success
fi
