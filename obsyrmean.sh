#!/bin/bash

#set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) GO "
   echo " This script will compute the annular mean for all varibles in diags directory. Currently from 1992 to 2015. "
   exit
fi 

# Calculation of yearly means with cdfmoy for transport, fresh water flux and sssth means in the files we have in diags dir
mkdir -p $WORKDIR/TMP$$
cd $WORKDIR/TMP$$
mkdir -p $DIAGDIR/1993-2015

for yr in {1993..2015} ; do
ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_0m${sal}.nc .
#ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_${sal}.nc .
ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_0m${sal}mean.nc .
#ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_${sal}mean.nc .
done
# Concatenate them betwen each other for the whole period of run
for typ in ${sal}mean ${sal} ; do 
    ncrcat -O ${CONFCASE}_y????_0m${typ}.nc $DIAGDIR/1993-2015/${CONFCASE}_y1993-2015_0m${typ}.nc
    #ncrcat -O ${CONFCASE}_y????_${typ}.nc $DIAGDIR/1993-2015/${CONFCASE}_y1993-2015_${typ}.nc
done

#1993 - for NNATL12, 1993 - for NNATLYS12
mkdir -p $DIAGDIR/1993-2010

for yr in {1993..2010} ; do
ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_0m${sat}.nc .
#ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_${SIC}.nc .
#ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_${sat}.nc .
ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_0m${sat}mean.nc .
#ln -sf $DIAGDIR/${yr}/${CONFCASE}_y????_${sat}mean.nc .
done
#ncrcat -O ${CONFCASE}_y????_${SIC}.nc $DIAGDIR/1993-2010/${CONFCASE}_y1993-2010_${SIC}.nc
# Concatenate them betwenn each other for the whole period of run
for typ in ${sat}mean ${sat} ; do 
    ncrcat -O ${CONFCASE}_y????_0m${typ}.nc $DIAGDIR/1993-2010/${CONFCASE}_y1993-2010_0m${typ}.nc
    #ncrcat -O ${CONFCASE}_y????_${typ}.nc ${CONFCASE}_y1993-2010_${typ}.nc
    #mv ${CONFCASE}_y1993-2010_${typ}.nc $DIAGDIR/1993-2010/
done
cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

