#
# Makefile
#

ITEMS=build/items/*.items
RULES=build/rules/*.rules
SITEMAPS=build/sitemaps/*.sitemap

#DOCKER_IMAGE="cyberkov/openhab2:offline"
DOCKER_IMAGE="cyberkov/openhab:amd64-offline"
CONTAINER_NAME="openhab2"
#VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/userdata:/openhab/userdata -v /opt/openhab/config:/openhab/conf:ro
#VOLUMES=-v /opt/openhab/config:/openhab/conf:ro
VOLUMES=-v /opt/openhab/userdata:/openhab/userdata \
  -v /opt/openhab/config:/openhab/conf \
  -v /opt/openhab/addons:/openhab/addons \
  -v /opt/openhab/config/extra/50-zwave.rules:/etc/udev/rules.d/50-zwave.rules:ro
#VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/config:/openhab/conf:ro

.PHONY: all update pull run clean purgelogs
all: update pull purgelogs run

items: items/all.items

items/all.items: $(ITEMS)
	for ITEM in build/items/*.items; do \
	  echo "// FILE: $$ITEM" >> $@.tmp; \
	  cat $$ITEM | egrep -v '^//|^$$' >> $@.tmp; \
	done
	mv $@.tmp $@

sitemaps: sitemaps/default.sitemap

sitemaps/default.sitemap: $(SITEMAPS)
	for ITEM in build/sitemaps/*.sitemap; do \
	  echo "// FILE: $$ITEM" >> $@.tmp; \
	  cat $$ITEM | egrep -v '^//|^$$' >> $@.tmp; \
	done
	mv $@.tmp $@

rules: rules/all.rules

rules/all.rules: $(RULES)
	for ITEM in build/rules/*.rules; do \
	  echo "// FILE: $$ITEM" >> $@.tmp; \
	  cat $$ITEM | egrep -v '^//|^$$' >> $@.tmp; \
	done
	mv $@.tmp $@

rules-override:
	-rm rules/all.rules
	cp build/rules/*.rules rules/

update:
	git pull
	blackbox_postdeploy
	make rules items sitemaps

pull:
	docker pull $(DOCKER_IMAGE)

run: items rules-override sitemaps
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
	  --device=$(shell realpath /dev/ttyUSBrfxcom0) \
	  --device=$(shell realpath /dev/ttyUSBzwave0) \
	  --name $(CONTAINER_NAME) \
	  $(DOCKER_IMAGE) \
	  debug
	  #dockerize -stdout /openhab/userdata/logs/openhab.log /openhab/start.sh debug

clean:
	-rm items/*.items
	-rm sitemaps/*.sitemap
	-rm rules/*.rules
	-rm -Rf /opt/openhab/userdata
purgelogs:
	rm -Rf /opt/openhab/userdata/logs/*
	mkdir -p /opt/openhab/userdata/logs
	mkdir -p /opt/openhab/userdata/persistence/mapdb
	touch /opt/openhab/userdata/logs/openhab.log
	chown cyberkov:cyberkov -R /opt/openhab/userdata/
