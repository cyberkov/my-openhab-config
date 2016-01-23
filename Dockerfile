# OpenHAB 2.0.0
# * configuration is injected
#
FROM java:8u45-jre
MAINTAINER Hannes Schaller <admin@cyberkov.at>

RUN apt-get update \
	&& apt-get install -y \
						supervisor \
						unzip \
						wget \
                                                inotify-tools \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#ENV OPENHAB_VERSION SNAPSHOT 
#ENV OPENHAB_VERSION 2.0.0.alpha2

#
# Install OpenHAB2
#
RUN echo "Downloading OpenHAB2..." \
	&& wget --quiet --no-cookies -O /tmp/runtime.zip https://openhab.ci.cloudbees.com/job/openHAB-Distribution/lastSuccessfulBuild/artifact/distributions/openhab-online/target/openhab-online-2.0.0-SNAPSHOT.zip \
	&& echo "Extracting OpenHAB2..." \
	&& mkdir -p /opt/openhab \
	&& unzip -q -d /opt/openhab /tmp/runtime.zip \
	&& rm /tmp/runtime.zip \
	&& rm /opt/openhab/*.bat \
	&& chmod +x /opt/openhab/start.sh \
	&& chmod +x /opt/openhab/start_debug.sh \
	&& mv /opt/openhab/conf /opt/openhab/default_conf \
	&& mv /opt/openhab/userdata /opt/openhab/default_userdata

#
# Setup other configuration files and scripts
#
COPY files/pipework /usr/local/bin/pipework
COPY files/supervisord.conf /etc/supervisor/supervisord.conf
COPY files/openhab.conf /etc/supervisor/conf.d/openhab.conf
COPY files/openhab_debug.conf /etc/supervisor/conf.d/openhab_debug.conf
COPY files/boot.sh /usr/local/bin/boot.sh
COPY files/openhab-restart /etc/network/if-up.d/openhab-restart

VOLUME ["/opt/openhab/conf", "/opt/openhab/userdata", "/opt/openhab/addons"]

EXPOSE 8080 8443 5555 9001

CMD ["/usr/local/bin/boot.sh"]
