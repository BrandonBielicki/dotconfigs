#! /bin/sh

sudo systemctl enable lightdm.service

if grep -Fxq "greeter-session = lightdm-gtk-greeter" /etc/lightdm/lightdm.conf; then
    echo "  Lightdm-gtk-greeter already configured" >> $LOGFILE
else
    sudo bash -c 'echo "greeter-session = lightdm-gtk-greeter" >> /etc/lightdm/lightdm.conf'
fi

