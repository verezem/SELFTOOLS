#!/bin/bash

set -x

# This is a script to calculate timeseries of MLD in Labrador and Irminger Seas 
# Uses CDFTOOLSv4

source ./header.sh
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi

# Set working dir
year=$1 # year is the first argument of the srpt 

# Calculation of yearly means with cdfmoy for transport, fresh water flux and sssth means in the files we have in diags dir
mkdir -p $WORKDIR/TMP$$
cd $WORKDIR/TMP$$
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
for mon in {1..4} ; do
   ln -sf $SWDIR/$year/${CONFCASE}_y${year}m0${mon}*.${freq}_${GRID1}.nc ./
done
ncrcat ${CONFCASE}_y${year}m0*.${freq}_${GRID1}.nc ${CONFCASE}_y${year}wint_${GRID1}.nc
ncks -v somxl010,sosstsst,nav_lat,nav_lon ${CONFCASE}_y${year}wint_${GRID1}.nc tmp_${CONFCASE}_y${year}wint_${GRID1}.nc
for var in $MXL10 $SST ; do
    cdfmean -f tmp_${CONFCASE}_y${year}wint_${GRID1}.nc -v ${var} -p T -w 202 226 186 213 1 1 -o $DIAGDIR/${year}/LS1_${CONFCASE}_y${year}wint_${var}.nc
    cdfmean -f tmp_${CONFCASE}_y${year}wint_${GRID1}.nc -v ${var} -p T -w 234 266 283 305 1 1 -o $DIAGDIR/${year}/LS2_${CONFCASE}_y${year}wint_${var}.nc
    cdfmean -f tmp_${CONFCASE}_y${year}wint_${GRID1}.nc -v ${var} -p T -w 399 426 195 227 1 1 -o $DIAGDIR/${year}/IS1_${CONFCASE}_y${year}wint_${var}.nc
done

cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

