#! /bin/sh

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE=$SRCDIR/../logs/log
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> $LOGFILE
echo "  Entered $0" >> $LOGFILE
USER=$1
HOMEDIR="$(eval echo ~$USER)"
echo "  Running as user $USER" >> $LOGFILE
echo "  $USER's home directory: $HOMEDIR" >> $LOGFILE

su $USER -c "xfconf-query -c pointers -p /ETPS2_Elantech_Touchpad/Properties/Synaptics_Tap_Action -n -t int -t int -t int -t int -t int -t int -t int  -s 0 -s 0 -s 0 -s 0 -s 1 -s 3 -s 2"
su $USER -c "xfconf-query -c pointers -p /ETPS2_Elantech_Touchpad/Properties/libinput_Tapping_Enabled -n -t int -s 1"

su $USER -c "xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/Super_L' -n -t string -s 'xfce4-terminal --drop-down'"
su $USER -c "xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt>Super_L' -n -t string -s 'xfce4-terminal'"
su $USER -c "xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Shift>Super_L' -n -t string -s 'chromium'"

sudo systemctl set-default graphical.target
sudo systemctl enable NetworkManager.service

git config --global user.email "Brandonbielicki@gmail.com"
git config --global user.name "Brandon Bielicki"

cd $SRCDIR
touch ../work/settings
