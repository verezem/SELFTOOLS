#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATL12
CASE=MP9

# Frequency of the output used in this case
freq=5d

CONFCASE=${CONFIG}-${CASE}

# Set constant variables
lv=2.5e6 # latent heat of vaporization [J/kg] or [m2/s2]
ts=86400. # number of seconds per day

# Paths to data and codes to work with
IDIR=$WORKDIR/$CONFIG/${CONFIG}-I
SWDIR=$WORKDIR/$CONFIG/${CONFCASE}-S/$freq
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
EOF
eof

# grid type and varaible type
GRID1=gridT
GRID2=flxT
SSH=sossheig
LHF=solhflup
PRECIP=sowapre
DAMP=sowafld
RNF=sornf
