#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATL12
CASE=CCI

# Frequency of the output used in this case
freq=1d

CONFCASE=${CONFIG}-${CASE}

# Paths to data and codes to work with
IDIR=/scratch/cnt0024/hmg2840/pverezem/${CONFCASE}
SWDIR=$WORKDIR/NNATL12-CCI
DIAGDIR=$WORKDIR/$CONFIG/${CONFCASE}-DIAGS

# grid type and varaible type
GRID3=gridI
var=satseice
SIC=satseice
ice=satseice
