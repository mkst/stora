#!/bin/bash

# purpose: installs nzbget
# version: 1.0

# setup variables
nzb_home="/home/nzbget"
nzbgetd_location="./daemons/nzbgetd"

# install nzbget using ipkg
/opt/bin/ipkg install nzbget

# install unrar too
/opt/bin/ipkg install unrar

# set home directory, umask to 0000 and parcheck to yes...
sed /opt/share/doc/nzbget/nzbget.conf.example -e "s#~/download#${nzb_home}#"\
                                              -e "s#UMask=1000#UMask=0000#"\
                                              -e "s#DirectWrite=no#DirectWrite=yes#"\
                                              -e "s#PostProcess=#PostProcess=${nzb_home}/postprocess.sh#"\
                                              -e "s#ParCheck=no#ParCheck=yes#" > /usr/etc/nzbget.conf

# copy example post-process script + conf
cp /opt/share/doc/nzbget/postprocess-example.sh ${nzb_home}/postprocess.sh
cp /opt/share/doc/nzbget/postprocess-example.conf ${nzb_home}/postprocess-example.conf

# setup nzbget daemon
cp ${nzbgetd_location} /etc/init.d/nzbgetd
chmod +x /etc/init.d/nzbgetd

# start at boot
/sbin/chkconfig --add nzbgetd
/sbin/chkconfig --level 235 nzbgetd on

# start daemon
/etc/init.d/nzbgetd start
