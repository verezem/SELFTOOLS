#!/bin/bash

set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source ./header.sh

# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <mon> "
   exit
fi

# Set working dir
mon=$1 # year is the first argument of the srpt

# Calculation of yearly means with cdfmoy for exact files we have in diags dir
mkdir -p $WORKDIR/TMP$$
cd $WORKDIR/TMP$$
mkdir -p $DIAGDIR/${mon}
for year in {2002..2015} ; do
   ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}m*.nc ./
done
for mon in {01..12} ; do
for var in $GRID1 $GRIDS ; do
#for var in $GRID1 ; do
#ncrcat $DIAGDIR/${mon}/${CONFCASE}_y????m${mon}_${var}surf.nc $DIAGDIR/${mon}/${CONFCASE}_m${mon}_${var}surf.nc 
ncrcat $DIAGDIR/${mon}/${CONFCASE}_y????m${mon}_${var}.nc $DIAGDIR/${mon}/${CONFCASE}_m${mon}_${var}.nc 
done
cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

