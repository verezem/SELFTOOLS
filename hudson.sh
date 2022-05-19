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
WRKDIR=$WORKDIR/TMP_03/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


cd $WRKDIR
#ln -sf $SWDIR/$year/${CONFCASE}_y${year}m03*.${freq}_grid2D.nc ./
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m03*.${freq}_grid[TS].nc ./
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m0[67]*.${freq}_${GRID3}.nc ./
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m1[12]*.${freq}_${GRID3}.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for mon in 06 07 11 12 ; do
for fl in ${CONFCASE}_y${year}m${mon}*.${freq}_${GRID3}.nc ; do
tmp=$( echo $(basename $fl) | awk -F_ '{ print $2}' )
ncks -v siconc,nav_lat,nav_lon $fl ${CONFCASE}_${tmp}_siconc.nc
done
done
for fl in ${CONFCASE}_y${year}m03*.${freq}_${GRID1}.nc ; do
tmp=$( echo $(basename $fl) | awk -F_ '{ print $2}' )
ncks -v vosaline,nav_lat,nav_lon -d deptht,1 ${fl} ${CONFCASE}_${tmp}_vosaline.nc
done

cdfmoy -l ${CONFCASE}_y${year}m0[67]d*_siconc.nc -o ${CONFCASE}_y${year}_summer_siconc
cdfmoy -l ${CONFCASE}_y${year}m1[12]d*_siconc.nc -o ${CONFCASE}_y${year}_winter_siconc
cdfmoy -l ${CONFCASE}_y${year}m03d*_vosaline.nc -o ${CONFCASE}_y${year}m03_vosaline
# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}_*siconc.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}m03_vosaline.nc $DIAGDIR/$year
cd $WORKDIR/TMP_03
rm -rf $year   # in order to erase tmp directory
