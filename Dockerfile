# Base system is Ubuntu 16.04
FROM   ubuntu:16.04

# set environment variables
ENV MURMUR_VERSION=1.2.13

# Add helper files
COPY scripts/repositories /etc/apk/repositories
COPY scripts/murmer /etc/murmur/murmur.ini
COPY scripts/docker-murmur /usr/bin/docker-murmur

# Download and install everything from the repos.
RUN    DEBIAN_FRONTEND=noninteractive \
        apt-get -y update && \
        apt-get -y install bzip2
        
GET https://github.com/mumble-voip/mumble/releases/download/${MURMUR_VERSION}/murmur-static_x86-${MURMUR_VERSION}.tar.bz2
RUN tar jxf  murmur-static_x86-${MURMUR_VERSION}.tar.bz2 \
    && mkdir /opt/murmur \
    && mv murmur-static_x86-${MURMUR_VERSION}/* /opt/murmur \
    && chmod 700 /usr/bin/docker-murmur

# Exposed port
EXPOSE 64738/tcp 64738/udp
WORKDIR /etc/murmur

# Add the data volume for data persistence
VOLUME ["/etc/murmur", "/var/lib/murmur", "/var/log/murmur"]

# Start murmur in the foreground
CMD "/usr/bin/docker-murmur"
