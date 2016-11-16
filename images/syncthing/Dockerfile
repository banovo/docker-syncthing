FROM ubuntu:16.04
MAINTAINER Patrick Kaiser <docker@pk.banovo.de>

# Variables
# -----------------------------------------------------------------------------
ENV CONTAINER_USER run
ENV PATH "$PATH:/opt/syncthing/bin"
ENV TZ "Europe/Berlin"

# Copy binaries and entrypoint
# Latest Release from https://build.syncthing.net/job/syncthing/lastStableBuild/artifact/
# -----------------------------------------------------------------------------
COPY sources/gosu-amd64 /usr/local/bin/gosu
COPY sources/syncthing /opt/syncthing/bin/syncthing
COPY docker-entrypoint.sh /usr/local/bin

# Install CA-Certificates and curl
# -----------------------------------------------------------------------------
RUN apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && apt-get install curl ca-certificates -y --no-install-recommends \
    && apt-get autoremove -y \
    && apt-get clean

# Setup Container user
# uid + guid will be changed on container startup on demand and set to values
# defined in ENV vars
# -----------------------------------------------------------------------------
RUN set -x \
    && addgroup --gid 9001 ${CONTAINER_USER} \
    && adduser --uid 9001 --gid 9001 --shell /bin/bash --home /home/${CONTAINER_USER} --gecos "" --disabled-password ${CONTAINER_USER}

# Base packages
# -----------------------------------------------------------------------------
RUN set -x \
    && chmod +x /usr/local/bin/gosu \
    && chmod +x /opt/syncthing/bin/syncthing \
    && chmod +x /usr/local/bin/docker-entrypoint.sh \
    && gosu nobody true \
    && mkdir -p /opt/syncthing/etc && mkdir -p /opt/syncthing/var

EXPOSE 8384
EXPOSE 22000
EXPOSE 21027/udp

VOLUME /opt/syncthing/etc
VOLUME /opt/syncthing/var

WORKDIR /opt/syncthing/bin

CMD ["syncthing"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
