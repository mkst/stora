# stora
All-in-one script for Netgear Stora

Forum thread @ http://www.openstora.com/forum/viewtopic.php?f=1&t=471

Feel free to branch and/or create pull requests for additional features.

# instructions

## bootstrap
You need git, and to get git you need ipkg, so follow these instructions:
```
$ sudo bash -c "$(wget https://raw.githubusercontent.com/streetster/stora/mark/scripts/installipkg.sh -O -)"
$ sudo /opt/bin/ipkg install git
$ /opt/bin/git clone https://github.com/streetster/stora.git
$ cd stora && git checkout mark
$ sudo ./aio.sh
```
