FROM alpine:latest

LABEL maintainer="Klaus Frank <https://github.com/agowa338>"

RUN apk add --no-cache \
    glib \
    pcre \
    eventlog \
    openssl \
    tini \
    && apk add --no-cache --virtual .build-deps \
    autoconf \
    autoconf-archive \
    automake \
    libtool \
    bison \
    flex \
    hiredis \
    hiredis-dev \
    curl \
    alpine-sdk \
    glib-dev \
    pcre-dev \
    eventlog-dev \
    openssl-dev \
    && set -ex \
    && cd /tmp \
    && git clone https://github.com/syslog-ng/syslog-ng.git \
    && cd syslog-ng \
    && git submodule update --init --remote --recursive \
    && ./autogen.sh \
    && ./configure -q --prefix=/usr \
    && /bin/ash -c 'make -j $(nproc)' \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/* \
    && apk del --no-cache .build-deps \
    && mkdir -p /etc/syslog-ng /var/run/syslog-ng /var/log/syslog-ng

ADD syslog-ng.conf /etc/syslog-ng

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="syslog-ng-alpine" \
      org.label-schema.description="Minimal Syslog Build on Alpine" \
      org.label-schema.url="https://hub.docker.com/r/agowa338/syslog-ng-alpine/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d -p 514:514/udp --name syslog-ng agowa338/syslog-ng-alpine"

VOLUME ["/var/log/syslog-ng", "/var/run/syslog-ng", "/etc/syslog-ng"]

EXPOSE 514/udp 514/tcp 601/tcp 6514/tcp

ENTRYPOINT ["tini", "--"]

CMD ["/usr/sbin/syslog-ng", "-F", "-f", "/etc/syslog-ng/syslog-ng.conf"]
