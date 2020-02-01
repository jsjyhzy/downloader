#!/bin/bash

MINIO=/usr/bin/minio
MINIO_DATA=/downloader/minio-virtual
mkdir -p $MINIO_DATA
ln -s /data $MINIO_DATA/$MINIO_LOCATION

$MINIO server $MINIO_DATA