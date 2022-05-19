#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATLYS12
CASE=ISAS

# Frequency of the output used in this case
freq=1m

CONFCASE=${CONFIG}-${CASE}

# Paths to data and codes to work with
IDIR=/scratch/cnt0024/hmg2840/pverezem/${CONFCASE}
SWDIR=$WORKDIR/${CONFCASE}
DIAGDIR=$WORKDIR/$CONFIG/${CONFCASE}-DIAGS

lev1000=35
# grid type and varaible type
GRID1=gridT
GRIDS=gridS
GRIDU=gridU
GRIDV=gridV

# define variable names for config
exsal="-s ${CONFCASE}_y${year}m${mon}d${dd}_${GRIDS}.nc"
