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
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d*.${freq}_${GRID1}.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
#cp /scratch/cnt0024/hmg2840/pverezem/NNATL12/NNATL12-MP4.21-S/5d/ice_mask.nc ice_mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

reg='NAT'

IRM="-w 349 557 146 318"
LAB="-zoom 81 345 98 399 1 43"
LAB2="-zoom 81 345 98 399 1 51"

# Main body
for mon in {01..12} ; do
cdfmoy -l ${CONFCASE}_y${year}m${mon}*.${freq}_${GRID1}.nc -var votemper -o ${CONFCASE}_y${year}m${mon}_gridT
#cdfheatc -f ${CONFCASE}_y${year}m${mon}d0[12345].${freq}_gridT.nc -zoom 0 0 0 0 1 31 -o ${CONFCASE}_y${year}m${mon}_ohc200.nc 
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 1 27 -o ${CONFCASE}_y${year}m${mon}_ohc200.nc 
#cdfheatc2d -f ${CONFCASE}_y${year}m${mon}d15.${freq}_${GRID1}.nc -zoom 0 0 0 0 1 39 -o ${CONFCASE}_y${year}m${mon}_ohc1500 -map
#cdfheatc2d -f ${CONFCASE}_y${year}m${mon}.${freq}_gridT.nc -zoom 0 0 0 0 1 75 -o ${CONFCASE}_y${year}m${mon}_ohcfull -map
#cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 27 43 -o ${CONFCASE}_y${year}m${mon}_ohc700.nc
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 1 43 -o ${CONFCASE}_y${year}m${mon}_ohc700.nc
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 43 51 -o ${CONFCASE}_y${year}m${mon}_ohc1500.nc
#cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 34 38 -o ${CONFCASE}_y${year}m${mon}_ohc1500.nc
cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 51 75 -o ${CONFCASE}_y${year}m${mon}_ohc3000.nc
#cdfheatc -f ${CONFCASE}_y${year}m${mon}_gridT.nc -zoom 0 0 0 0 38 50 -o ${CONFCASE}_y${year}m${mon}_ohc3000.nc
done

#for dep in 1500 ; do
for dep in 200 700 1500 3000 ; do
ncrcat -h -O ${CONFCASE}_y${year}m*_ohc${dep}.nc ${CONFCASE}_y${year}_ohc${dep}.nc
#ncrcat -h -O ${CONFCASE}_y${year}m*_ohc${dep}map.nc ${CONFCASE}_y${year}_ohc${dep}map.nc
mv ${CONFCASE}_y${year}_ohc${dep}.nc $DIAGDIR/$year
#mv ${CONFCASE}_y${year}_ohc${dep}map.nc $DIAGDIR/$year
done

cd $WORKDIR/TMP_OHC
rm -rf $year   # in order to erase tmp directory
