#!/bin/bash

######################################################
# storaSetup.sh
#
# v0.05 (2017.01.15)
#
######################################################
# Changelog:
#
# 0.01 - Initial Version
# 0.02 - Uses functions, new menu system
# 0.03 - Added Transmission
# 0.04 - Moved files to github
# 0.05 - Split out scripts into separate files
#
######################################################

######################################################
#                   FUNCTIONS                        #
######################################################

drawMenu() {
# clear the screen
clear
# draw the menu
cat <<MENU_END

  ######################################################
  # Welcome to the stora all-in-one script...
  ######################################################

  What would you like to do:

  1) Setup the PATH variable/environment
  2) Swap the SSH Daemon with a clean version
  3) Install the IPKG Package Manager
  4) Move /opt to the HDD
  5) Install Kernel NFS
  6) Remove Access Patrol
  7) Install NZBget
  8) Install NZBget-server
  9) Install Transmission

  X. eXit

  Option: _

  $1

MENU_END

tput cup 19 10
read -r selection

case ${selection} in
  1) clear; setPath;;
  2) clear; replaceSSHd;;
  3) clear; installIPKG;;
  4) clear; moveOpt;;
  5) clear; installNFS;;
  6) clear; disableAP;;
  7) clear; installNZBget;;
  8) clear; installNZBgetWeb;;
  9) clear; installTransmission;;
  X|x|Q|q) tput sgr0; echo ""; exit 0;;
  *) TEXT="Error: Invalid Selection";;
esac
}

setText() {
  if [[ "$1" = "" ]]; then
    TEXT=""
  elif [[ "$1" = "0" ]]; then
    TEXT="Result: OK"
  else
    TEXT="Result: FAIL"
  fi
  echo "Press ENTER to continue"
  read -r blah
}

internetCheck() {
  source ./scripts/internetcheck.sh
  res="$?"
  echo ${res}
}

setPath() {
  echo "Setting up PATH variable..."
  source scripts/setpath.sh
  #TODO: check if ap running first...
  disableAP
  setText "$?"
}

replaceSSHd() {
  echo "Replacing SSH Daemon..."
  source scripts/replacesshd.sh
  setText "$?"
}

installIPKG() {
  if [ ! -e /opt/bin/ipkg ]; then
    if [[ "$(internetCheck)" -eq "0" ]]; then
      echo "Installing IPKG..."
      source scripts/installipkg.sh
      setText "$?"
    else
      echo "Internet check failed"
      setText 1
    fi
  else
    echo "IPKG already installed"
  fi
}

moveOpt() {
  echo "Moving /opt to harddrive..."
  source scripts/moveopt.sh
  setText "$?"
}

installNFS() {
  echo "Installing Kernel NFS"
  source scripts/installnfs.sh
  setText "$?"
}

installNZBget() {
  echo "Installing NZBget..."
  # check we have ipkg
  installIPKG
  # check we have internet access
  if [[ "$(internetCheck)" -eq "0" ]]; then
    source scripts/installnzbget.sh
    setText "$?"
  else
    echo "No internet connection."
    setText 1
  fi
}

installNZBgetWeb() {
  echo "Setting up NZBGET-web..."
  source scripts/installnzbgetweb.sh
  setText "$?"
}

disableAP() {
  echo "Disabling Access Patrol..."
  source scripts/disableap.sh
  setText "$?"
}

installTransmission() {
  echo "Installing Transmission..."
  # check if we have IPKG
  installIPKG
  # check we have internet access
  if [[ "$(internetCheck)" -eq "0" ]]; then
    # install transmission
    source scripts/installtransmission.sh
    setText "$?"
  else
    echo "No internet connection."
    setText 1
  fi
}

######################################################

# check that we are root before starting
if [[ ! "$(whoami)" = "root" ]] ; then
  echo ""
  echo "  Error: You must have root privileges to run this script."
  echo ""
  echo "         Try again using 'sudo $0'."
  echo ""
  # die
  exit 1
fi

# nice and white
tput bold

TEXT=""
while true
do
  if [ ! "$TEXT" = "" ]; then
    foo="$TEXT"
    TEXT=""
    drawMenu "$foo"
  else
    drawMenu
  fi
done
