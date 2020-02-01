#!/bin/bash

NGINX=$(which nginx)

if [ ! -f /config/www.conf ]
then
    envsubst '${MINIO_LOCATION}' < /downloader/template/www.template > /config/www.conf
fi

$NGINX -g 'daemon off;'