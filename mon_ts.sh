#!/bin/bash

set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh

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
for year in {1993..2010} ; do
   ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}m*.nc ./
done
mkdir -p $DIAGDIR/${mon}
for var in $SST $SSS ; do
ncrcat ${CONFCASE}_y????m${mon}_${var}.nc $DIAGDIR/${mon}/${CONFCASE}_m${mon}_${var}.nc 
done
cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

