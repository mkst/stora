#!/bin/bash

# purpose: installs nzbget web front-end
# version: 1.0

# variables
nzbgetweb_location="./dl/nzbgetweb-1.4.zip"
rpclib_location="./dl/xmlrpc-2.2.2.tar.gz"
tmp="/tmp/"

# grab unzip if we dont have it already
if [ ! -e /opt/bin/unzip ]
then
    /opt/bin/ipkg install unzip
fi

# we can share the http server by placing files in /var/www/
/opt/bin/unzip -d /var/www ${nzbgetweb_location}

# we also need the PHP RPC library
tar -xzf ${rpclib_location} -C ${tmp}
cp -r ${tmp}xmlrpc-2.2.2/lib /var/www/nzbgetweb/lib

# set permissions
chmod -R 755 /var/www/nzbgetweb/
chown -R apache:www /var/www/nzbgetweb/

# setup the alias
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.original
echo 'Alias /nzbgetweb/ "/var/www/nzbgetweb/"' >> /etc/httpd/conf/httpd.conf

# restart httpd daemon
/sbin/service httpd reload

# clean-up
rm -r ${tmp}xmlrpc-2.2.2
