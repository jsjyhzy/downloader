# <============== Section of Aria2 builder ==============>
FROM alpine:3.11 as aria-builder

ENV ARIA2_TAG=release-1.34.0

RUN apk update &&\
    apk add git c-ares-dev libxml2-dev \
            libssh2-dev libssh2-static \
            zlib-dev zlib-static \
            sqlite-dev sqlite-static \
            openssl-dev openssl-libs-static \
            gettext-dev gettext-static \
            expat-dev xz-dev \
            cppunit-dev autoconf automake libtool build-base &&\
    update-ca-certificates &&\
    git clone https://github.com/aria2/aria2.git &&\
    cd aria2 &&\
    git checkout $ARIA2_TAG &&\
    autoreconf -i &&\
    ./configure ARIA2_STATIC=yes --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt' &&\
    make &&\
    make check

# <============== Section of AriaNG provider ==============>
FROM alpine:3.11 as ariang-provider

ENV ARIANG_VERSION=1.1.4

WORKDIR /ariang

RUN apk update &&\
    apk add wget &&\
    wget https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip -O ariang.zip &&\
    mkdir html &&\
    unzip -o ariang.zip -d /ariang/html

# <============== Section of MinIO provider ==============>
FROM minio/minio as minio-provider

RUN uname

# <============== Section of Main Image ==============>
FROM alpine:3.11

ENV MINIO_UPDATE=off \
    CONF_PATH=/data/config

ENV MINIO_ACCESS_KEY="download" \
    MINIO_SECRET_KEY="download" \
    RPC_SECRET="download"

WORKDIR /downloader
VOLUME [ "/data" ]

COPY template /downloader/template
COPY scripts /downloader/scripts
COPY --from=aria-builder /aria2/src/aria2c /usr/bin/aria2c
COPY --from=ariang-provider /ariang/html /var/www/html
COPY --from=minio-provider /usr/bin/minio /usr/bin/minio

EXPOSE 80

RUN apk update &&\
    apk add --no-cache ca-certificates nginx parallel &&\
    chmod +x /usr/bin/aria2c &&\
    chmod +x /usr/bin/minio &&\
    update-ca-certificates &&\
    rm /etc/nginx/conf.d/* &&\
    ln -s ${CONF_PATH}/www.conf /etc/nginx/conf.d/www.conf &&\
    ln -sf /dev/stdout /var/log/nginx/access.log &&\
    ln -sf /dev/stderr /var/log/nginx/error.log

ENTRYPOINT [ "sh", "scripts/startup.sh" ]