#Schallerburg OpenHAB Config

This is my currently running openHAB2 configuration.
- It is set up on a Intel NUC with Debian 8.0. OpenHAB installation is done through the [Docker image](https://hub.docker.com/r/openhab/openhab/).
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

##Things in use
| Amount | Item | Description |
|---|---|---|
|13 | HM-CC-RT-DN | Wireless Radiator Thermostat |
| 3 | HM-ES-PMSw1-Pl | Wireless Switch Actuator 1-channel with power metering |
| 2 | HM-ES-TX-WM | Energymeter |
| 2 | HM-LC-Sw1-FM | Switch Actuator |
| 1 | HM-OU-CFM-Pl | MP3 Radio chime with light flash and memory |
| 1 | HM-PB-2-WM55-2 | Wireless Push-Button 2-channel |
| 1 | HM-PBI-4-FM | Wireless Interface 4 channel, flush-mount |
| 2 | HM-RC-Sec4-2 | Wireless remote control |
| 3 | HM-Sec-MDIR-2 | Wireless motion detector |
| 1 | HM-Sec-SC | Wireless Shutter Contact |
| 10 | HM-Sec-SCo | Wireless Door/Window Sensor, optical |
| 1 | HM-Sec-SFA-SM | Radio-controlled alarm siren and flash actuator surface-mount |
| 1 | HM-WDS10-TH-O | Wireless Temperature/Humidity Sensor, outdoor (OTH) |
| 5 | HM-WDS40-TH-I-2 | Wireless Temperature/Humidity Sensor,indoor |


##Additional software used

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
