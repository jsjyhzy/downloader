#!/bin/bash

ARIA2=/usr/bin/aria2c
touch /config/aria2.session

if [ ! -f /config/aria2.conf ]
then
    envsubst '${RPC_SECRET}' < /downloader/template/aria2.template > /config/aria2.conf
fi

$ARIA2 --conf-path=/config/aria2.conf
