#! /bin/sh

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE=$SRCDIR/../logs/log
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> $LOGFILE
echo "  Entered $0" >> $LOGFILE
USER=$1
HOMEDIR="$(eval echo ~$USER)"
echo "  Running as user $USER" >> $LOGFILE
echo "  $USER's home directory: $HOMEDIR" >> $LOGFILE

sudo add-apt-repository -y ppa:mystic-mirage/komodo-edit

VER=$(cat /etc/debian_version)
ID="${VER%/*}"
echo "  distro name: $ID" >> $LOGFILE
echo "deb http://deb.torproject.org/torproject.org $ID main" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://deb.torproject.org/torproject.org $ID main" | sudo tee -a /etc/apt/sources.list
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

sudo add-apt-repository ppa:webupd8team/tor-browser

sudo apt-get update

cd $SRCDIR
touch ../work/ppa_setup
