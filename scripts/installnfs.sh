#!/bin/bash

# purpose: installs nfs server
# version: 1.0

# setup variables
nfs_kernel_version="2.6.22.18-Netgear"
nfs_location="./dl/nfs-utils_STORA.tar.gz"

# check kernel
if [[ $(uname -r) = "${nfs_kernel_version}" ]]; then
  # extract to /
  tar -xzf ${nfs_location} -C /

  # load module
  /sbin/depmod -a
  /sbin/modprobe nfsd

  # add default share
  echo "/home/0common 192.168.1.0/255.255.255.0(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports

  # remove v4 support
  mv /etc/sysconfig/nfs /etc/sysconfig/nfs.original
  sed /etc/sysconfig/nfs.original 's/^#RPCNFSDARGS="-N\ 4"/RPCNFSDARGS="-N\ 4"/' > /etc/sysconfig/nfs

  # start daemons
  /etc/init.d/portmap start
  /etc/init.d/nfs start

  # start at boot
  /sbin/chkconfig --add portmap
  /sbin/chkconfig --level 235 portmap on
  /sbin/chkconfig --add nfs
  /sbin/chkconfig --level 235 nfs on

  # check it looks ok
  /sbin/exportfs -v
else
    # wrong kernel version
    echo "Error: Incorrect kernel version. Found: $(uname -r), required: ${nfs_kernel_version}"
    return 2
fi
