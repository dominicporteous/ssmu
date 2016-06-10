# Base system is Ubuntu 16.04
FROM   ubuntu:16.04

# set environment variables
ENV MURMUR_VERSION=1.2.13

# Add helper files
ADD ./scripts/repositories /etc/apk/repositories
ADD ./scripts/murmer /etc/murmur/murmur.ini
ADD ./scripts/start /start

# Download and install everything from the repos.
RUN    DEBIAN_FRONTEND=noninteractive \
        apt-get -y update && \
        apt-get -y install bzip2
        
ADD https://github.com/mumble-voip/mumble/releases/download/${MURMUR_VERSION}/murmur-static_x86-${MURMUR_VERSION}.tar.bz2 ./
RUN tar jxf  murmur-static_x86-${MURMUR_VERSION}.tar.bz2 \
    && mkdir /opt/murmur \
    && mv murmur-static_x86-${MURMUR_VERSION}/* /opt/murmur \
    && chmod 700 /usr/bin/docker-murmur

# Exposed port
EXPOSE 64738/tcp 64738/udp

RUN useradd murmur
USER murmur
VOLUME ["/etc/murmur", "/var/lib/murmur", "/var/log/murmur"]
CMD ["/usr/bin/dockermurmur"]
