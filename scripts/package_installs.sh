#! /bin/sh

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE=$SRCDIR/../logs/log
PACKAGESLOG=$SRCDIR/../logs/packages
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> $LOGFILE
echo "  Entered $0" >> $LOGFILE
USER=$1
HOMEDIR="$(eval echo ~$USER)"
echo "  Running as user $USER" >> $LOGFILE
echo "  $USER's home directory: $HOMEDIR" >> $LOGFILE

while getopts ":r" OPTION; do
    case $OPTION in
        r)
            echo "  r flag detected" >> $LOGFILE 
            reinstall=true
            ;;
        \?)
            echo "pass r to reinstall"
            exit
            ;;
    esac
done
reinstall=true

# $1 = package name
# $2 = git url
# $3 = makefile location
function gitInstall {
    if [ ! -f "$HOMEDIR/bin/$1" ]; then
        RETDIR=$PWD
        echo "  Installing $1..." >> $LOGFILE
        cd $HOMEDIR/bin
        su $USER --session-command "git clone $2 $1.d"
        cd $1.d/$3
        echo "  Installing to $PWD" >> $LOGFILE
        su $USER --session-command "make"
        su $USER --session-command "cp $HOMEDIR/bin/$1.d/$3/$1 $HOMEDIR/bin/"
        if [ -f "$HOMEDIR/bin/$1" ]; then
            echo "$1 Installed" >> $PACKAGESLOG
        else
            echo "$1 FAILED" >> $PACKAGESLOG
        fi
        rm -r -f $HOMEDIR/bin/$1.d
        cd $RETDIR
    else
        echo "  $1 already installed" >> $LOGFILE
        if [ "$reinstall" = true ]; then
            echo "  Reinstalling $1" >> $LOGFILE
            rm $HOMEDIR/bin/$1
            rm -r -f $HOMEDIR/bin/$1.d
            install $1 $2 $3
        fi
    fi
}

# $1 = package name
# $2 = git url
function aurInstall {
    if [ ! -d "$HOMEDIR/bin/src/$1.d" ]; then
        RETDIR=$PWD
        echo "  Installing $1..." >> $LOGFILE
        cd $HOMEDIR/bin/src
        su $USER --session-command "git clone $2 $1.d"
        cd $1.d
        echo "  Installing to $PWD" >> $LOGFILE
        su $USER --session-command "makepkg -sri --needed --noconfirm"
        if [ $? = 0 ]; then
            echo "$1 Installed" >> $PACKAGESLOG
        else
            echo "$1 FAILED" >> $PACKAGESLOG
        fi
        rm -r -f $1.d
        cd $RETDIR
    else
        echo "  $1 already installed" >> $LOGFILE
        if [ "$reinstall" = true ]; then
            echo "  Reinstalling $1" >> $LOGFILE
            sudo rm -r -f $HOMEDIR/bin/src/$1.d
            install $1 $2
        fi
    fi
}

function fileByLine {
    echo "  Reading from file: $1" >> $LOGFILE
    while read -r PACKAGE || [ -n "$PACKAGE" ]; do
        case "$PACKAGE" in
            [\AUR\]*)
                aurInstall ${PACKAGE:5}
                ;;
            [\GIT\]*)
                gitInstall ${PACKAGE:5}
                ;;
            *)
                $PM $PACKAGE
                if [ $? = 0 ]; then
                    echo "$PACKAGE Installed" >> $PACKAGESLOG
                else
                    echo "$PACKAGE FAILED" >> $PACKAGESLOG
                fi
                ;;
        esac
    done < $1
}

if [ -f /etc/debian_version ]; then
    PM="sudo apt-get -y install"
    PACKAGE_LIST="apt_packages"
    GROUPDIR="apt"
    echo "  package manager command: $PM" >> $LOGFILE
    sudo apt-get -y update 
elif [ -f /etc/arch-release ]; then
    PM="sudo pacman -S --noconfirm --needed"
    echo "  package manager command: $PM" >> $LOGFILE
    PACKAGE_LIST="pacman_packages"
    GROUPDIR="pacman"
    sudo pacman -Syu --noconfirm
fi


fileByLine ../setup/package_lists/$PACKAGE_LIST
fileByLine ../setup/package_lists/universal_packages

while read -r ITEM || [ -n "$ITEM" ]; do
    echo "  Installing packages from group $ITEM" >> $LOGFILE
    case "$ITEM" in \#*) continue ;; esac
    fileByLine ../setup/package_lists/.groups/$GROUPDIR/$ITEM
    fileByLine ../setup/package_lists/.groups/$ITEM
done < ../setup/package_lists/group_packages

cd $SRCDIR
touch ../work/package_installs
