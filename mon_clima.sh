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
#for sec in 60N AR7W ovide A24N ; do
for sec in 60N ovide ; do
   mkdir -p $DIAGDIR/${mon}
      for year in {2002..2015} ; do
         ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}_${sec}.nc ./
         ncks -F -O -d time_counter,${mon} ${CONFCASE}_y${year}_${sec}.nc $DIAGDIR/${mon}/${CONFCASE}_y${year}m${mon}_${sec}.nc 
      done
      ncrcat $DIAGDIR/${mon}/${CONFCASE}_y????m${mon}_${sec}.nc $DIAGDIR/${mon}/${CONFCASE}_m${mon}_${sec}.nc 
      #rm $DIAGDIR/${mon}/${CONFCASE}_y????m${mon}_${sec}.nc
done

cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

