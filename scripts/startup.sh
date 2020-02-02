#!/bin/bash

SPATH=/downloader/scripts

ls $SPATH | grep -v startup.sh | parallel --tag --line-buffer --workdir $SPATH bash {}