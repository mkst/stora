#!/bin/bash

# purpose: disables Netgear Access Patrol
# version: 1.0

# stop service
echo "Stopping access-patrol service"
/etc/init.d/access-patrol stop

# remove from boot
echo "Removing access-patrol from startup"
/sbin/chkconfig --levels 2345 access-patrol off

# remove executable flag
echo "Removing execute flag from access-patrol"
chmod a-x /usr/sbin/access-patrol
