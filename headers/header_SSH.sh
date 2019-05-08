#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATL12
CASE=SSH

# Frequency of the output used in this case
freq=1d

CONFCASE=${CONFIG}-${CASE}

# Paths to data and codes to work with
IDIR=/scratch/cnt0024/hmg2840/pverezem/${CONFCASE}
SWDIR=$WORKDIR/NNATL12-SSH
DIAGDIR=$WORKDIR/$CONFIG/${CONFCASE}-DIAGS

# grid type and varaible type
GRID1=gridT
var=sossheig
sah=sossheig
SSH=sossheig
