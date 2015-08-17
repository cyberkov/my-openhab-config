Schallerburg OpenHAB Config
===

This is my currently running openHAB configuration.
- It is set up on a Raspberry Pi2 with Raspbian 8.0. OpenHAB installation is done through the packages (btw there is also a [Puppet Module](https://forge.puppetlabs.com/cyberkov/openhab) to install it)
- The sensitive files are encrypted using [Blackbox](https://github.com/StackExchange/blackbox).
- Deployment of Git checkins is done with Jenkins.


Right now I'm using the following bindings:
* [Pushover notifications](http://pushover.net)
* Homematic
* [MySensors](http://www.mysensors.org) - build your own sensors with arduino
* RFXCOM - enables switching of cheap powerplugs like Intertechno
* XBMC - every TV has one with a central MariaDB on the NAS
* MQTT (attached to the [mosquitto](http://mosquitto.org/) server running on the same RPi)

The mysensors sources can be found at http://github.com/cyberkov/mysensors

Monkeypatches
---
I symlinked some of the folders (especially the images and the folder) to /etc/openhab to put everything into one proper repo. This does not go very well with the [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard), but it works :-)

Additional software used
---
I found the RRD diagrams a bit cumbersome so I started using [InfluxDB](http://influxdb.org).
Unfortunately there is no arm package yet. Therefore all metrics are sent via MQTT to my webserver and pumped into InfluxDB with [mqttwarn](https://github.com/jpmens/mqttwarn).
mqttwarn is also able to create Nagios alerts and Pushover notifications but this is still on my To-Do list.

Sources
---
Not all of the rules are my original idea and I therefor do not claim any copyright. Unfortunately everything evolved over time so I cannot tell anymore which is from where.
A few sources I can name (and also would like to take the opportunity to thank them) are:
* [Marianne Spiller](https://github.com/sysadmama/openhab)
* [Stein Tore](https://github.com/steintore/my-openhab-config)
* the openHAB Google Group
* KNX User Forum
* [JP Mens](https://github.com/jpmens)
