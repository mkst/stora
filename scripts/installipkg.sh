#!/bin/bash

# purpose: manually install ipkg
# version: 1.0

# setup variables
tmp="/tmp/"
ipkg_location="http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/stable/ipkg-opt_0.99.163-10_arm.ipk"

# wget
wget -O ${tmp}ipkg.ipk ${ipkg_location}

if [[ -s ${tmp}ipkg.ipk ]]; then
  # extract
  tar -xzf ${tmp}ipkg.ipk -C ${tmp}
  tar -xzf ${tmp}data.tar.gz -C /

  # add source
  echo "src cs08q1armel http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/stable" >> /opt/etc/ipkg.conf

  # refresh sources
  /opt/bin/ipkg update

  # clean-up
  rm ${tmp}data.tar.gz
  rm ${tmp}control.tar.gz
  rm ${tmp}debian-binary
  rm ${tmp}ipkg.ipk
else
  echo "Error: Failed to download ipkg"
  return 1
fi
