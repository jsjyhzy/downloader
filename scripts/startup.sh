#!/bin/sh

SPATH=/downloader/scripts

mkdir -p $CONF_PATH

ls $SPATH | grep -v startup.sh | parallel -j3 --tag --line-buffer --workdir $SPATH bash {}