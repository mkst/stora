#!/bin/bash

# purpose: mounts HDD as /opt for more storage space
# version: 1.0

# check that user has a HDD installed
if [[ ! $(df | grep "/mnt/disk") ]]; then
  echo "Error: No HDD present"
  return 1
fi

# check that opt is not already a symlink
if [[ $(file /opt | grep directory) ]]; then
  # copy everything from internal /opt to HDD
  cp -r /opt /home/opt
  # rename old
  mv /opt /opt-old
  # symbolic link to hdd
  ln -s /home/opt /opt
else
  echo "Warning: /opt is already a symbolic link"
fi
