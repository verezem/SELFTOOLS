#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate SSH over domain mean values, [m]
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Set working dir
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_OHC/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_gridT.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for mon in {01..12} ; do
cdfmoy -l ${CONFCASE}_y${year}m${mon}*.${freq}_gridT.nc -o ${CONFCASE}_y${year}m${mon}_gridT
#cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 1 31 -o ${CONFCASE}_y${year}m${mon}_ohc200.nc 
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 1 27 -o ${CONFCASE}_y${year}m${mon}_ohc200.nc 
#cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 1 43 -o ${CONFCASE}_y${year}m${mon}_ohc700.nc
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 1 34 -o ${CONFCASE}_y${year}m${mon}_ohc700.nc
#cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 43 51 -o ${CONFCASE}_y${year}m${mon}_ohc1500.nc
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 34 38 -o ${CONFCASE}_y${year}m${mon}_ohc1500.nc
#cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 51 75 -o ${CONFCASE}_y${year}m${mon}_ohc3000.nc
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 38 50 -o ${CONFCASE}_y${year}m${mon}_ohc3000.nc
done

for dep in 200 700 1500 3000 ; do
ncrcat ${CONFCASE}_y${year}m*_ohc${dep}.nc ${CONFCASE}_y${year}_ohc${dep}.nc
mv ${CONFCASE}_y${year}_ohc${dep}.nc $DIAGDIR/$year
done

cd $WORKDIR/TMP_OHC
rm -rf $year   # in order to erase tmp directory
