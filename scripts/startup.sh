#!/bin/bash

NGINX=$(which nginx)
ARIA2=/usr/bin/aria2c
MINIO=/usr/bin/minio

web_engine () {
    $NGINX -g 'daemon off;'
}

aria_engine () {
    touch /config/aria2.session
    $ARIA2 --conf-path=/config/aria2.conf
}

s3_engine () {
    $MINIO /data
}

watchdog () {
    while true
    do
        sleep 5
        nginx_pid=$(pgrep nginx)
        aria2_pid=$(pgrep aria2c)
        minio_pid=$(pgrep minio)
        if [ -z "$nginx_pid" || -z "$aria2_pid" || -z "$minio_pid" ]
        then
            if [ -z "$nginx_pid" ]; then echo "Nginx failed"; fi
            if [ -z "$aria2_pid" ]; then echo "Aria2 failed"; fi
            if [ -z "$minio_pid" ]; then echo "Minio failed"; fi
            kill $nginx_pid $aria2_pid $minio_pid
            break
        fi
    done
}

parallel --tag --line-buffer ::: web_engine aria_engine s3_engine watchdog | tr -s ab