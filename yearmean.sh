#!/bin/bash

#set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source ./header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) GO "
   echo " This script will compute the annular mean for all varibles in diags directory. Currently from 1992 to 2014. "
   exit
fi 

# Calculation of yearly means with cdfmoy for all the files we have in diags dir
mkdir -p $WORKDIR/TMP$$
cd $WORKDIR/TMP$$
for year in {1992..2014} ; do
cdfmoy -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_[Nn]orthtrp.nc -o ${CONFCASE}_y${year}_northtrp 
cdfmoy -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_[Ss]outhtrp.nc -o ${CONFCASE}_y${year}_southtrp 
cdfmoy -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_fwfl.nc -o ${CONFCASE}_y${year}_fwfl 
cdfmoy -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sshmean.nc -o ${CONFCASE}_y${year}_sshmean
done

mkdir -p $DIAGDIR/1992-2014

for typ in northtrp southtrp fwfl sshmean ; do
ncrcat ${CONFCASE}_y????_${typ}.nc $DIAGDIR/1992-2014/${CONFCASE}_y1992-2014_${typ}.nc
done
cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

