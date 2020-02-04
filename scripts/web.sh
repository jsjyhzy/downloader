#!/bin/bash

NGINX=$(which nginx)

mkdir -p /run/nginx

if [ ! -f /config/www.conf ]
then
    cp /downloader/template/www.template ${CONF_PATH}/www.conf
fi

$NGINX -g 'daemon off;'