#!/bin/bash

parallel --tag --line-buffer ::: web_engine aria_engine s3_engine mywatchdog | tr -s ab