FROM resin/rpi-raspbian:jessie
MAINTAINER kl82@me.com

RUN apt-get update \
 && apt-get install -y \
    libtool-bin \
    libdaemon-dev \
    libasound2-dev \
    libpopt-dev \
    libconfig-dev \
    avahi-daemon \
    libavahi-client-dev \
    libpolarssl-dev \
    libsoxr-dev \
    git \
    autoconf \
    ca-certificates \
    automake \
    libicu52 \
    libpsl0 \
    libssl-dev \
    make \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN cd /root \
 && git clone https://github.com/mikebrady/shairport-sync.git \
 && cd /root/shairport-sync \
 && git checkout development \
 && autoreconf -i -f \
 && ./configure --with-alsa --with-pipe --with-avahi --with-ssl=polarssl --with-soxr --with-metadata \
 && make \
 && make install \
 && rm /etc/avahi/avahi-daemon.conf
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf

COPY start.sh /start

ENV AIRPLAY_NAME Docker

ENTRYPOINT [ "/start" ]
