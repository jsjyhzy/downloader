#!/bin/bash

ARIA2=/usr/bin/aria2c
touch /config/aria2.session
$ARIA2 --conf-path=/config/aria2.conf
