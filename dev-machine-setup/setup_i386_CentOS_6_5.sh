#!/bin/bash

# 0. Check if user has sudo permissions, if not exit
## making sure script is not being run under root, if it does just exit
if [[ $UID -eq 0 ]]
then 
    echo 'do NOT run this script under root!'
    exit 1
fi
## invalidate any cached sudo, prompt for password
sudo -kk
sudo whoami >/dev/null
## actually checks if sudo credentials were cached successfully
if [[ $(sudo whoami) == 'root' ]] 
then
    echo 'great! user has sudo!'
else
    echo 'Seems like user does not have sudo!'
    echo 'Please visit this page to read how to grant permissions to user:'
    echo 'https://www.digitalocean.com/community/articles/how-to-edit-the-sudoers-file-on-ubuntu-and-centos'
    exit 1
fi
# Pretty good explanation on how to make your user account to be in the sudoers file
# sudo visudo
# https://www.digitalocean.com/community/articles/how-to-edit-the-sudoers-file-on-ubuntu-and-centos

# Script to configure Dev Machine and install tools for x64 platform
clear
yum -y update
yum -y upgrade

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

clear
# 1. Download sublime Text 3 beta (on current moment, Jan 25, 2014 - build 3059)
cd ~/Downloads
pwd
wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x32.tar.bz2
tar -xf sublime_text_3_build_3059_x32.tar.bz2

# 1.1 Create a Desktop shortcut
cp -f ~/Downloads/sublime_text_3/sublime_text.desktop ~/Desktop/
sed -i "s/Icon=sublime-text/Icon=\/opt\/sublime_text\/Icon\/256x256\/sublime-text.png/g" ~/Desktop/sublime_text.desktop
chmod 755 ~/Desktop/sublime_text.desktop
sudo mv -f ~/Downloads/sublime_text_3 /opt/sublime_text

# 1.1.1 Create a symlink for 'subl'
sudo ln -s /opt/sublime_text/sublime_text /usr/bin/subl

# 1.2 Install Package Control
wget https://sublime.wbond.net/Package%20Control.sublime-package
mkdir -p --verbose ~/.config/sublime-text-3/Installed\ Packages/
mv -f ~/Downloads/Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages/

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 2. Download and install IntelliJ (on current moment, Jan 25, 2013 - 13 EAP - 133.696)
cd ~/Downloads
pwd
wget http://download.jetbrains.com/idea/ideaIU-13.1.1.tar.gz
tar -xzvf ideaIU-13.1.1.tar.gz
sudo mv -f ~/Downloads/idea-IU-135.480 /opt/

# 2.1 Create a symlink
sudo ln -s /opt/idea-IU-135.480/bin/idea.sh /usr/bin/idea 

# 2.2 Create a Desktop shortcut
cat << EOF >> ~/Desktop/idea.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA 13.1
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
Exec=/usr/bin/idea %F
Terminal=false
MimeType=text/plain;
Icon=/opt/idea-IU-135.480/bin/idea.png
Categories=TextEditor;Development;
StartupNotify=true
Actions=Window;Document;
EOF

chmod 755 ~/Desktop/idea.desktop
