#!/bin/bash

SPATH=/downloader/scripts

mkdir -p $CONF_PATH

ls $SPATH | grep -v startup.sh | parallel --tag --line-buffer --workdir $SPATH bash {}