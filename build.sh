#! /bin/sh

#CREATE=false
#while getopts ":c" OPTION; do
#    case $OPTION in
#        c)
#            CREATE=true
#            ;;
#        \?)
#            echo "pass c to create user with default configs"
#            exit
#            ;;
#    esac
#done

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1" ]; then
    echo "Must provide username to install"
    echo ./build user
    exit
fi
USER=$1

#if [ "$CREATE" = "true"]; then
#    echo "Creating user $1"
#else
#    echo "Building as user $1"
#fi

HOMEDIR="$(eval echo ~$USER)"

if [ ! -d $HOMEDIR ]; then
    echo "Users home directory not found... does this user exist?"
    exit
fi
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LOGFILE=$SRCDIR/logs/log
if [ ! -d "$SRCDIR/logs" ]; then
    mkdir $SRCDIR/logs
fi
if [ ! -d "$SRCDIR/work" ]; then
    mkdir $SRCDIR/work
fi
if [ -f "$SRCDIR/logs/log" ]; then
    echo Logfile exists, deleting
    rm "$SRCDIR/logs/log"
fi

echo "Source Directory: $SRCDIR" >> $LOGFILE
echo "Home Directory: $HOMEDIR" >> $LOGFILE
chown $USER:users $LOGFILE
#chmod 755 $LOGFILE

# Make home bin directory
if [ ! -d "$HOMEDIR/bin" ]; then
    echo "No home bin directory... creating now" >> $LOGFILE
    su $USER --session-command "mkdir $HOMEDIR/bin"
    echo "Make $HOMEDIR/bin status: $?" >> $LOGFILE
    su $USER --session-command "mkdir $HOMEDIR/bin/src"
    echo "Make $HOMEDIR/bin/src status: $?" >> $LOGFILE
else
    echo "Home bin directory already installed" >> $LOGFILE
fi

#Add user to sudoers
if grep -Fxq "$USER ALL=(ALL) ALL" /etc/sudoers; then
    echo "User already in /etc/sudoers" >> $LOGFILE
else
    echo "User not in /etc/sudoers... adding now" >> $LOGFILE
    echo "$USER ALL=(ALL) ALL" >> /etc/sudoers
fi


if [ -f /etc/debian_version ]; then
    cd $SRCDIR/scripts
    echo "Distro: debian" >> $LOGFILE
    declare -a SCRIPTS=("ppa_setup" "package_installs" "settings" "dotconfig")
    for item in "${SCRIPTS[@]}"; do
        if [ ! -f "$SRCDIR/work/$item" ]; then 
            echo "Entering $item" >> $LOGFILE
            sudo ./$item.sh $USER
        else
            echo "$item in work directory... skipping" >> $LOGFILE
        fi
    done
elif [ -f /etc/arch-release ]; then
    cd $SRCDIR/scripts
    echo "Distro: arch" >> $LOGFILE
    declare -a SCRIPTS=("package_installs" "settings" "dotconfig")
    for item in "${SCRIPTS[@]}"; do
        if [ ! -f "$SRCDIR/work/$item" ]; then 
            echo "Entering $item" >> $LOGFILE
            sudo ./$item.sh $USER
        else
            echo "$item in work directory... skipping" >> $LOGFILE
        fi
    done
fi

