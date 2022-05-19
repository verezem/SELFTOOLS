#!/bin/bash

# This is a header script for NEMO diagnostics support,
# runnning cdftools and other self-written tools.

# Name of config and case
CONFIG=NNATL12
CASE=MP4.21

# Frequency of the output used in this case
freq=1d
freq2=1d
CONFCASE=${CONFIG}-${CASE}

# Set constant variables
lv=2.5e6 # latent heat of vaporization [J/kg] or [m2/s2]
ts=86400. # number of seconds per day

# Paths to data and codes to work with
IDIR=$WORKDIR/$CONFIG/${CONFIG}-I
SWDIR=$WORKDIR/$CONFIG/${CONFCASE}-S/$freq
SWDIR2=$WORKDIR/$CONFIG/${CONFCASE}-S/$freq2
DIAGDIR=$WORKDIR/$CONFIG/${CONFCASE}-DIAGS

# define sections for particular config-case

section_file=section.dat
# any amount of sections: 2 lines for each section and EOF in the end in this manner:
# NAME 
# imin imax jmin jmax
#cat << eof > $section_file
#South
#1 934 3 3
#North
#934 1 399 399 
#EOF
#eof

# grid type and varaible type
GRID1=gridTsurf #if 1d output is used
GRIDU=gridU
GRIDV=gridV
GRID2=flxT
GRID3=icemod3
SSH=sossheig
LHF=solhflup
SHF=sosbhfup
NET=sohefldo
SIC=siconc
PRECIP=sowapre
DAMP=sowafld
RNF=sornf
SST=votemper
SSS=vosaline
MXL10=somxl010
lev100=31
depu=depthu
depv=depthv
sal=vosaline
sat=votemper
