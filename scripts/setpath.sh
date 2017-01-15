#!/bin/bash

# purpose: sets up the user's /etc/environment
# version: 1.0

# setup new path variable
NEW_PATH="/usr/local/bin:/usr/bin:/bin:/opt/bin:/usr/sbin:/opt/sbin:/usr/sbin:/sbin"

#export the path too
export PATH=$NEW_PATH

# set the environment
echo "PATH=$NEW_PATH" > /etc/environment
