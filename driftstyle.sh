#!/bin/bash

set -x

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
lev=11 # for NNATLYS12 - 11

# path to workdir
WRKDIR=$WORKDIR/TMP_DRF/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

for mon in {01..12} ; do
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m${mon}*.${freq}_${GRIDU}.nc ./
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m${mon}*.${freq}_${GRIDV}.nc ./
# Main body
for var in $GRIDU $GRIDV ; do
for fl in ${CONFCASE}_y${year}m${mon}*.${freq}_${var}.nc ; do
tmp=$( echo $(basename $fl) | awk -F_ '{ print $2}' )
if [ $CASE == 'V1' ]
then
   dep=deptht
elif [ $var == 'gridU' ]
then
   dep=$depu
elif [ $var == 'gridV' ]
then
   dep=$depv
fi
ncks -F -O -d ${dep},${lev} $fl ${CONFCASE}_${tmp}_50m${var}.nc
done
cdfmoy -l ${CONFCASE}_y${year}m${mon}*.${freq}_50m${var}.nc -o ${CONFCASE}_y${year}m${mon}.${freq}_50m${var}
done
done

# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}m??.${freq}_50m${GRIDU}.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}m??.${freq}_50m${GRIDV}.nc $DIAGDIR/$year
cd $WORKDIR/TMP_DRF
rm -rf $year   # in order to erase tmp directory
