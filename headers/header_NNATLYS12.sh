#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATLYS12
CASE=V1

# Frequency of the output used in this case
freq=1d

CONFCASE=${CONFIG}-${CASE}

# Set constant variables
lv=2.5e6 # latent heat of vaporization [J/kg] or [m2/s2]
ts=1 # beacuse in GLORYS data they are already divided by 86400 s

# Paths to data and codes to work with
IDIR=/scratch/cnt0024/hmg2840/pverezem/${CONFCASE}
SWDIR=$WORKDIR/NNATLYS12-V1
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
GRID2=grid2D
GRID1=gridT
GRIDS=gridS
GRIDU=gridU
GRID3=grid2D
GRIDV=gridV
SSH=sossheig
LHF=socelatf
SHF=socesenf
PRECIP=sowaprec
RNF=sorunoff
NET=sohefldo
SIC=siconc
SST=votemper
SSS=vosaline
MXL10=somxl010
lev1000=35
depu=deptht
depv=deptht
sat=votemper
sal=vosaline
# define variable names for config
exsal="-s ${CONFCASE}_y${year}m${mon}_${GRIDS}.nc"
#extra="-M NNATLYS12_byte_mask.nc tmask"
#cmdcp="cp $IDIR/NNATLYS12_byte_mask.nc ." #copying special files for particular case
