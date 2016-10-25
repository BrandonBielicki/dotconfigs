# Dotconfigs

A framework for auto-configuring linux systems and syncing configurations between machines

## Running

To run the program:
    
    sudo ./build {user}
    
To copy current configuration into repository:

    sudo ./package

## Configure and Customize

the setup directory contains a folder called package_lists. This directory contains all the info required for installing packages. The directory contains multiple files, designating the packages to be installed by the appropriate package manager.
- universal is for packages that are not distro specific
- group is for preconfigured groups, allowing the user to uncomment a line to install packages related to that group

## To-Do

- [x] Make package installs in single line statements to preserves single interupt exit
- [ ] Figure out how to prevent xfce4 panel overwrite - Session overwrites the files instatly. have to run outside of users session. Figure out how to prevent session from overwriting?
- [x] Allow installation for another user other than current
- [ ] Pass a flag and a aurgument to manually specify package manager
- [ ] Add config files to easily choose and manage desktop environments and managers
- [ ] Remove personal settings and configure as template
- [x] One install script for packages, git, aur. [GIT] [AUR] prefixes to designate
- [x] A log file with a list of each package attempted to be installed, and if succesful
- [ ] split package file into sections to skip using work folder
