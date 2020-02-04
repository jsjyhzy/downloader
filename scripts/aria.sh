#!/bin/sh

ARIA2=/usr/bin/aria2c
touch ${CONF_PATH}/aria2.session

if [ ! -f /config/aria2.conf ]
then
    cp /downloader/template/aria2.template ${CONF_PATH}/aria2.conf
    sed -i "s/@RPC_SECRET/${RPC_SECRET}/g" ${CONF_PATH}/aria2.conf
fi

$ARIA2 --conf-path=${CONF_PATH}/aria2.conf
