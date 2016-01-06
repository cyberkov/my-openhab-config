build: Dockerfile
	docker build -t cyberkov/openhab2 .

run:
	/usr/bin/docker run --rm --net host -m 0b -e SERVICE_NAME=openhab -e SERVICE_8080_CHECK_HTTP=/rest/sitemaps \
	  -p 8080:8080 -p 5555:5555 -p 9001:9001 -p 9123:9123 \
	  -v /opt/openhab/config:/etc/openhab \
	  -v /opt/openhab/config/keystore/keystore:/opt/openhab/runtime/etc/keystore:ro \
	  -v /opt/openhab/userdata:/opt/openhab/userdata \
	  --device=/dev/ttyUSB0 \
	  --name oh2 \
	  cyberkov/openhab2
