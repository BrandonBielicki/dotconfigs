#! /bin/sh

if [ -z "$1" ]; then
	USER=$USER
else
	USER=$1
fi
HOMEDIR="$(eval echo ~$USER)"
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Copying files from $HOMEDIR/.config into $SRCDIR/files/.config"
cp -r $HOMEDIR/.config files/ 
