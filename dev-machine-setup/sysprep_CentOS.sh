#!/bin/bash

# This script created based on few sources:
# http://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/
# https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Evaluation_Guide/Evaluation_Guide-Create_RHEL_Template.html
# http://libguestfs.org/virt-sysprep.1.html

# Print version of OS
cat /etc/redhat-release

# 0. Install latest updates
yum -y update && yum -y upgrade

# 1. Clean Yum cache
# http://www.linuxcommand.org/man_pages/yum8.html
yum clean all

# 2. Force the logs to rotate
logrotate /etc/logrotate.conf -f -v
rm /var/log/*-???????? -f -v
rm /var/log/*.gz -f -v


# 3. Clear the audit log & wtmp
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp

# 4. Remove the traces of the template MAC address and UUIDs
ifdown eth0
sed -i.bak '/^\(HWADDR\|UUID\)=/d' /etc/sysconfig/network-scripts/ifcfg-eth0
ifup eth0

# 5. Remove the udev persistent device rules
# http://ss64.com/bash/sed.html
# cat /etc/udev/rules.d/70-persistent-net.rules | grep -v eth0 > /etc/udev/rules.d/70-persistent-net.rules
#sed -i.bak '/eth0/d' /etc/udev/rules.d/70-persistent-net.rules
rm /etc/udev/rules.d/70* -f -v

# 6. Clean /tmp out
rm /tmp/* -rf
rm /var/tmp/* -rf

# 7. Remove the SSH host keys
rm /etc/ssh/*key* -f -v

# 8. Remove the user’s shell history
rm ~/.bash_history -f -v 
unset HISTFILE

# 9. Flag the system for reconfiguration
touch /.unconfigured

# 10. Reset root password to blank and enforce to be changed on first login
usermod -p "" root
chage -d 0 root

# 11. Rename machine to generic name
# cat /etc/sysconfig/network | sed 's/HOSTNAME=.*/HOSTNAME=localhost.local/g'
sed -i.bak 's/HOSTNAME=.*/HOSTNAME=localhost.localdomain/g' /etc/sysconfig/network 

# 12. PowerOff
read -t30 -n1 -r -p "Press any key in the next 30 seconds for powering machine off..." key
poweroff


# 13. Zero out all free space
# Determine the version of RHEL

# FileSystem='grep ext /etc/mtab| awk -F" " ''{ print $2 }'''

# for i in $FileSystem
# do
#        echo $i
#        number='df -B 512 $i | awk -F" " ''{print $3}'' | grep -v Used'
#        echo $number
#        percent=$(echo 'scale=0; $number * 98 / 100' | bc )
#        echo $percent
#        dd count='echo $percent' if=/dev/zero of='echo $i'/zf
#        sync
#        sleep 15
#        rm -f $i/zf
# done

# VolumeGroup='vgdisplay | grep Name | awk -F  '{ print $3 }''

# for j in $VolumeGroup
# do
#        echo $j
#        lvcreate -l 'vgdisplay $j | grep Free | awk -F" " ''{ print $5 }''' -n zero $j
#        if [ -a /dev/$j/zero ]; then
#                cat /dev/zero > /dev/$j/zero
#                sync
#                sleep 15
#                lvremove -f /dev/$j/zero
#        fi
# done

# Post config - http://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-networkscripts-interfaces.html
