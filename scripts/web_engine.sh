#!/bin/bash

NGINX=$(which nginx)

$NGINX -g 'daemon off;'