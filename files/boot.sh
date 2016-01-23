#!/bin/bash

CONFIG_DIR=/opt/openhab/conf
DEFAULT_CONFIG=/opt/openhab/default_conf

USER_DIR=/opt/openhab/userdata
DEFAULT_USERDATA=/opt/openhab/default_userdata

####################
# Configure timezone

TIMEZONEFILE=$CONFIG_DIR/timezone

if [ -f "$TIMEZONEFILE" ]
then
  cp $TIMEZONEFILE /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

##############################################################
# Use default configuration if no configuration could be found

if ! [ "$(ls -A $CONFIG_DIR)" ]
then
	cp -r $DEFAULT_CONFIG/* $CONFIG_DIR
fi

####################################################
# Use default userdata if no userdata could be found

if ! [ "$(ls -A $USER_DIR)" ]
then
	cp -r $DEFAULT_USERDATA/* $USER_DIR
fi

######################
# Decide how to launch

ETH0_FOUND=`grep "eth0" /proc/net/dev`

if [ -n "$ETH0_FOUND" ] ;
then 
  # We're in a container with regular eth0 (default)
  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
else 
  # We're in a container without initial network.  Wait for it...
  /usr/local/bin/pipework --wait
  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
fi
