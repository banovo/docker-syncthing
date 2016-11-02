FROM ubuntu:16.04
MAINTAINER Patrick Kaiser <docker@pk.banovo.de>

# Variables
# -----------------------------------------------------------------------------
ENV CONTAINER_USER run
ENV PATH "$PATH:/opt/stdiscosrv/bin"
ENV TZ "Europe/Berlin"

# Copy binaries and entrypoint
# Latest Release from https://build.syncthing.net/job/stdiscosrv/lastSuccessfulBuild/artifact/
# -----------------------------------------------------------------------------
COPY sources/gosu-amd64 /usr/local/bin/gosu
COPY sources/stdiscosrv /opt/stdiscosrv/bin/stdiscosrv
COPY docker-entrypoint.sh /usr/local/bin

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
    && chmod +x /opt/stdiscosrv/bin/stdiscosrv \
    && chmod +x /usr/local/bin/docker-entrypoint.sh \
    && gosu nobody true \
    && mkdir -p /opt/stdiscosrv/etc && mkdir -p /opt/stdiscosrv/var

EXPOSE 8443

VOLUME /opt/stdiscosrv/var
WORKDIR /opt/stdiscosrv/bin

CMD ["stdiscosrv"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
