#!/bin/bash

# purpose: replaces ssh daeon with clean version
# version: 1.0

# setup variables
tmp="/tmp/"
sshd_location="./dl/sshd.tar.gz"

# extract to temp directory
tar -xzf ${sshd_location} -C ${tmp}

# backup original
cp /usr/sbin/sshd /usr/sbin/sshd.original
chmod -x /usr/sbin/sshd.original

# make executable and replace original
chmod +x ${tmp}sshd
mv ${tmp}sshd /usr/sbin/sshd

# restart ssh daemon
/etc/init.d/sshd restart
