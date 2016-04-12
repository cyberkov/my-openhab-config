#
# Makefile
#

ITEMS=src/items/*.items
RULES=src/rules/*.rules
SITEMAPS=src/sitemaps/*.sitemap

DOCKER_IMAGE="openhab/openhab:amd64-online"
#DOCKER_IMAGE="cyberkov/openhab:amd64-offline"
CONTAINER_NAME="openhab2"
#VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/userdata:/openhab/userdata -v /opt/openhab/config:/openhab/conf:ro
#VOLUMES=-v /opt/openhab/config:/openhab/conf:ro
VOLUMES=-v /opt/openhab/userdata:/openhab/userdata \
  -v /opt/openhab/config:/openhab/conf \
  -v /opt/openhab/addons:/openhab/addons
#VOLUMES=-v /opt/openhab/config/keystore/keystore:/openhab/userdata/etc/keystore:ro -v /opt/openhab/config:/openhab/conf:ro

.PHONY: all update pull run clean purgelogs config
all: update pull purge run
config: items sitemaps rules

items: items/all.items

items/all.items: $(ITEMS)
	for ITEM in src/items/*.items; do \
	  echo "// FILE: $$ITEM" >> $@.tmp; \
	  cat $$ITEM | egrep -v '^//|^$$' >> $@.tmp; \
	done
	mv $@.tmp $@

sitemaps: sitemaps/default.sitemap

sitemaps/default.sitemap: $(SITEMAPS)
	for ITEM in src/sitemaps/*.sitemap; do \
	  echo "// FILE: $$ITEM" >> $@.tmp; \
	  cat $$ITEM | egrep -v '^//|^$$' >> $@.tmp; \
	done
	mv $@.tmp $@

rules: rules-override

#rules/all.rules: $(RULES)
#	for ITEM in src/rules/*.rules; do \
#	  echo "// FILE: $$ITEM" >> $@.tmp; \
#	  cat $$ITEM | egrep -v '^//|^$$' >> $@.tmp; \
#	done
#	mv $@.tmp $@

rules-override:
	rsync -a --delete src/rules/*.rules rules/

update:
	git pull
	blackbox_postdeploy
	make rules items sitemaps

pull:
	docker pull $(DOCKER_IMAGE)

run: config
	/usr/bin/docker run \
	  --rm \
	  --net host \
	  -m 2048m \
	  -p 8080:8080 -p 5555:5555 -p 9123:9123 \
	  -e EXTRA_JAVA_OPTS='-Xmx2048m' \
	  -v '/etc/localtime:/etc/localtime:ro' \
	  -v '/etc/timezone:/etc/timezone:ro' \
	  -it \
	  $(VOLUMES) \
	  --device=$(shell realpath /dev/ttyUSBrfxcom0) \
	  --device=$(shell realpath /dev/ttyUSBzwave0) \
	  --name $(CONTAINER_NAME) \
	  $(DOCKER_IMAGE) \
	  debug
#	  -u root \

clean:
	-rm items/*.items
	-rm sitemaps/*.sitemap
	-rm rules/*.rules
	-rm -Rf /opt/openhab/userdata
	make phoenix
purge:
	rm -Rf /opt/openhab/userdata/logs/*
	chown cyberkov:cyberkov -R /opt/openhab/userdata/
phoenix:
	mkdir -p /opt/openhab/userdata/logs
	mkdir -p /opt/openhab/userdata/persistence/mapdb
	chown cyberkov:cyberkov -R /opt/openhab/userdata/

habmin:
	curl -Lo /opt/openhab/addons/org.openhab.ui.habmin_2.0.0.SNAPSHOT-0.1.2.jar https://github.com/cdjackson/HABmin2/raw/master/output/org.openhab.ui.habmin_2.0.0.SNAPSHOT-0.1.2.jar
