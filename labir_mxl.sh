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
mkdir -p $DIAGDIR/${year}
cd $WORKDIR/TMP$$
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
for mon in {01..04} ; do
   ln -sf $SWDIR2/$year/${CONFCASE}_y${year}m${mon}*.${freq2}_${GRID1}surf.nc ./
done
ncrcat ${CONFCASE}_y${year}m*.${freq2}_${GRID1}surf.nc ${CONFCASE}_y${year}_${GRID1}.nc
ncks -v somxl010,sosstsst,nav_lat,nav_lon ${CONFCASE}_y${year}_${GRID1}.nc tmp_${CONFCASE}_y${year}_${GRID1}.nc
for var in somxl010 ; do
    cdfmean -f tmp_${CONFCASE}_y${year}_${GRID1}.nc -v ${var} -p T -w 195 291 150 222 0 0 -o LS1_${CONFCASE}_y${year}_${var}.nc
    cdfmean -f tmp_${CONFCASE}_y${year}_${GRID1}.nc -v ${var} -p T -w 349 426 160 226 0 0 -o IS1_${CONFCASE}_y${year}_${var}.nc
done
mv *y${year}_somxl010.nc ${DIAGDIR}/${year}/
cd $WORKDIR
#rm -rf TMP$$   # in order to erase tmp directory

