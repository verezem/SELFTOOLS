#!/bin/bash

set -x

# This is a script to calculate monthly means for volumetric diagrams computation 
# The idea is:
# cdfcensus
# Uses CDFTOOLSv4

source ./header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Get year from screen
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP$$/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp ./sections/*.short.* $WRKDIR/
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_gridT.nc ./  # link files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

DMS="-zoom 430 602 284 360"

# Main body
for mon in {06..07} ; do
for dd in {01..30} ; do
if [ -z "$exsal" ]; then
cdfcensus -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc $DMS -srange 32 35.5 0.01 -trange -2 12 0.05 -o ${CONFCASE}_y${year}m${mon}d${dd}_DMStsdiag.nc 
else
exsal="-s ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDS}.nc" 
cdfcensus -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc $exsal $DMS -srange 32 35.5 0.01 -trange -2 12 0.05 -o ${CONFCASE}_y${year}m${mon}d${dd}_DMStsdiag.nc
fi
done
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat -O -h ${CONFCASE}_y${year}m*_DMStsdiag.nc $DIAGDIR/${year}/${CONFCASE}_y${year}m${mon}_DMStsdiag.nc  # ncrcat -h - is no history

cd $WORKDIR
rm -rf ./TMP$$   # in order to erase tmp directory
