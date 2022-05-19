#!/bin/bash

set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh

# Set working dir

# Calculation of yearly means with cdfmoy for exact files we have in diags dir
mkdir -p $WORKDIR/TMP$$
cd $WORKDIR/TMP$$
for var in $GRIDU $GRIDV ; do
   for mon in {01..12} ; do
   mkdir -p $DIAGDIR/${mon}
      for year in {1993..2015} ; do
         ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}m${mon}.${freq}_50m${var}.nc ./
      done
      cdfmoy_weighted -l ${CONFCASE}_y????m${mon}.${freq}_50m${var}.nc -o $DIAGDIR/${mon}/${CONFCASE}_m${mon}_15m${var}.nc 
   done
      #rm $DIAGDIR/${mon}/${CONFCASE}_y????m${mon}_${sec}.nc
done
cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

