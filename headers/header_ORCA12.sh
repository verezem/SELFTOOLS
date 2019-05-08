#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATL12
CASE=GLORYS2V4

# Frequency of the output used in this case
freq=1m

CONFCASE=${CONFIG}-${CASE}

# Set constant variables
lv=2.5e6 # latent heat of vaporization [J/kg] or [m2/s2]
ts=1. # number of seconds per day

# Paths to data and codes to work with
IDIR=$WORKDIR/$CONFIG/${CONFIG}-I
SWDIR=$WORKDIR/GLORYS025-NNATL12/NORCA12/$freq
DIAGDIR=$WORKDIR/$CONFIG/${CONFCASE}-DIAGS

# define sections for particular config-case

section_file=section.dat
# any amount of sections: 2 lines for each section and EOF in the end in this manner:
# NAME 
# imin imax jmin jmax
cat << eof > $section_file
South
1 934 3 3
North
934 1 399 399
Hudson
60 72 324 358
Denmark
914 924 204 238
EOF
eof

# define variable names for config
extra="-M NNATL12_byte_mask.nc_masked tmask"
cmdcp="cp $IDIR/NNATL12_byte_mask.nc_masked ." #copying special files for particular case

# grid type and varaible type
GRID=gridU
GRID1=gridT
GRID2=flxT
SSH=sossheig
LHF=solhflup
PRECIP=sowapre
DAMP=sowafld
RNF=sornf
