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


FROM minio/minio as minio-provider
RUN ls


FROM alpine:3.11

ENV ARIANG_VERSION=1.1.1

WORKDIR /aria2
VOLUME [ "/data" , "/config"]

COPY --from=aria-builder /aria2/src/aria2c /usr/bin/aria2c
COPY --from=minio-provider /usr/bin/minio /usr/bin/minio
COPY --from=minio-provider /usr/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
COPY template/aria2c.template .
COPY startup.sh .

EXPOSE 80 6800

RUN apk update &&\
    apk add --no-cache gettext ca-certificates&&\
    update-ca-certificates
RUN apk update &&\
    apk add --no-cache nginx wget &&\
    wget https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip -O ariang.zip &&\
    rm -r /var/www/html && mkdir /var/www/html &&\
    unzip -o ariang.zip -d /var/www/html &&\
    apk del wget

ENTRYPOINT [ "bash", "startup.sh" ]