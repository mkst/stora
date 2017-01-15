#!/bin/bash

# purpose: mounts HDD as /opt for more storage space
# version: 1.0

# check that user has a HDD installed
df | grep "/mnt/disk" > /dev/null
if [ "$?" -eq "1" ]; then
  echo "Error: No HDD present"
  return 1
fi

# copy everything from internal /opt to HDD
cp -r /opt /home/opt

# rename old
mv /opt /opt-old

# symbolic link to hdd
ln -s /home/opt /opt
