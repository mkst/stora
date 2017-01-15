#!/bin/bash

clear
echo "Hello there!"

# setup variables
nfs_kernel_version="4.4.0-45-generic" #"2.6.22.18-Netgear"
nfs_location="./dl/nfs-utils_STORA.tar.gz"

echo ${SUDO_USER}

# check kernel
if [[ "$(uname -r)" = "${nfs_kernel_version}" ]]; then
  echo "woop"
else
  echo "nope"
fi
