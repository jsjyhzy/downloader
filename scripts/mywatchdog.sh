#!/bin/bash

NGINX=$(which nginx)
ARIA2=/usr/bin/aria2c
MINIO=/usr/bin/minio

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
