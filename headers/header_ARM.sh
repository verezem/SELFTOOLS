#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATL12
CASE=ARM

# Frequency of the output used in this case
freq=1m

CONFCASE=${CONFIG}-${CASE}

# Paths to data and codes to work with
IDIR=/scratch/cnt0024/hmg2840/pverezem/${CONFCASE}
SWDIR=$WORKDIR/NNATL12-ARM
DIAGDIR=$WORKDIR/$CONFIG/${CONFCASE}-DIAGS

lev1000=47
# grid type and varaible type
GRID1=gridT
GRIDS=gridS
GRIDU=gridU
GRIDV=gridV
exsal="-s ${CONFCASE}_y${year}m${mon}_${GRIDS}.nc"
