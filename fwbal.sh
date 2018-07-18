#!/bin/bash

set -x

# This is a script to plot fresh water balance nicely with Python fwbal.py script.

source ./header.sh

WORKDIR=./
yr1=1992
yr2=2014

python fwbal_universal.py $WORKDIR $CONFIG $CASE $yr1 $yr2
