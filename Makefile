#
# Makefile
#

DOCKER_IMAGE="cyberkov/openhab2:offline"
CONTAINER_NAME="oh2"
VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/userdata:/openhab/userdata -v /opt/openhab/config:/openhab/conf:ro
VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/config:/openhab/conf:ro

.PHONY: all update pull run clean purgelogs
all: update pull purgelogs run

update:
	git pull
	blackbox_postdeploy

pull:
	docker pull $(DOCKER_IMAGE)

build: Dockerfile
	docker build -t cyberkov/openhab2 .

demo:
	/usr/bin/docker run \
	  --rm \
	  --net host \
	  -m 0b \
	  -p 8080:8080 -p 5555:5555 -p 9123:9123 \
	  -v '/etc/localtime:/etc/localtime:ro' \
	  -it \
	  --device=/dev/ttyUSB0 \
	  --name $(CONTAINER_NAME) \
	  $(DOCKER_IMAGE) \
	  dockerize -stdout /openhab/userdata/logs/openhab.log /openhab/start.sh debug

run: purgelogs
	/usr/bin/docker run \
	  --rm \
	  --net host \
	  -m 0b \
	  -p 8080:8080 -p 5555:5555 -p 9123:9123 \
	  -v '/etc/localtime:/etc/localtime:ro' \
	  -it \
	  $(VOLUMES) \
	  --device=/dev/ttyUSB0 \
	  --name $(CONTAINER_NAME) \
	  $(DOCKER_IMAGE) \
	  dockerize -stdout /openhab/userdata/logs/openhab.log /openhab/start.sh debug

clean:
	rm -Rf /opt/openhab/userdata
purgelogs:
	rm -Rf /opt/openhab/userdata/logs/*
	mkdir -p /opt/openhab/userdata/logs
	touch /opt/openhab/userdata/logs/openhab.log
