#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=GLORYS2
CASE=V4

# Frequency of the output used in this case
freq=1m

CONFCASE=${CONFIG}-${CASE}

# Set constant variables
lv=2.5e6 # latent heat of vaporization [J/kg] or [m2/s2]
ts=1 # beacuse in GLORYS data they are already divided by 86400 s

# Paths to data and codes to work with
IDIR=/scratch/cnt0024/hmg2840/pverezem/${CONFCASE}
SWDIR=$WORKDIR/TMP_GLO
DIAGDIR=$WORKDIR/$CONFIG/${CONFCASE}-DIAGS

# define sections for particular config-case

section_file=section.dat
# any amount of sections: 2 lines for each section and EOF in the end in this manner:
# NAME 
# imin imax jmin jmax
cat << eof > $section_file
South
867 1178 723 723
North
867 1178 855 855
EOF
eof

# define variable names for config
#extra="-M ORCA025.L75-MJM91_byte_mask.nc_masked tmask"
#cmdcp="cp $IDIR/ORCA025.L75-MJM91_byte_mask.nc_masked ." #copying special files for particular case

# grid type and varaible type
GRID1=gridT
GRIDS=gridS
GRIDU=gridU
GRIDV=gridV
GRIDW=gridW
GRID=grid2D
SST=votemper
SSS=vosaline
SSH=sossheig
LHF=socelatf
PRECIP=sowaprec
RNF=sorunoff
