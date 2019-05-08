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
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
#for var in T S ; do
#cdfmoy -l ${CONFCASE}_y${year}m03*.${freq}_grid${var}.nc  -o ${CONFCASE}_y${year}m03_grid${var}
#done

cdfmxl -t ${CONFCASE}_y${year}m03*_gridT.nc -s ${CONFCASE}_y${year}m03*_gridS.nc -o ${CONFCASE}_y${year}m03_mxl.nc 

# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}m03_mxl.nc $DIAGDIR/$year
cd $WORKDIR/TMP_03
rm -rf $year   # in order to erase tmp directory
