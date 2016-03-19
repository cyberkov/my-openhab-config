#
# Makefile
#

DOCKER_IMAGE="cyberkov/openhab2:offline"
CONTAINER_NAME="openhab2"
#VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/userdata:/openhab/userdata -v /opt/openhab/config:/openhab/conf:ro
#VOLUMES=-v /opt/openhab/config:/openhab/conf:ro
VOLUMES=-v /opt/openhab/userdata:/openhab/userdata -v /opt/openhab/config:/openhab/conf
#VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/config:/openhab/conf:ro

.PHONY: all update pull run clean purgelogs
all: update pull purgelogs run

update:
	git pull
	blackbox_postdeploy

pull:
	docker pull $(DOCKER_IMAGE)

run:
	/usr/bin/docker run \
	  --rm \
	  --net host \
	  -m 2048m \
	  -p 8080:8080 -p 5555:5555 -p 9123:9123 \
	  -e EXTRA_JAVA_OPTS='-Xmx2048m' \
	  -v '/etc/localtime:/etc/localtime:ro' \
	  -v '/etc/timezone:/etc/timezone:ro' \
	  -it \
	  -u root \
	  $(VOLUMES) \
	  --device=/dev/ttyUSB0 \
	  --name $(CONTAINER_NAME) \
	  $(DOCKER_IMAGE) \
	  dockerize -stdout /openhab/userdata/logs/openhab.log /openhab/start.sh debug
	  #debug

clean:
	rm -Rf /opt/openhab/userdata
purgelogs:
	rm -Rf /opt/openhab/userdata/logs/*
	mkdir -p /opt/openhab/userdata/logs
	mkdir -p /openhab/userdata/persistence/mapdb
	touch /opt/openhab/userdata/logs/openhab.log
	chown cyberkov:cyberkov -R /opt/openhab/userdata/
