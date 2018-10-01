#!/bin/bash

set -x

# This is a script to calculate SSH over domain mean values, [m]
# Uses CDFTOOLSv4

source ./header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Set working dir
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_MEAN/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


for var in T U V ; do
#for var in T ; do
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_grid${var}surf.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
#cdfmoy -l ${CONFCASE}_y${year}m??*.${freq}_grid${var}surf.nc -max -o ${CONFCASE}_y${year}_mean_grid${var}surf
cdfstd -l ${CONFCASE}_y${year}m??*.${freq}_grid${var}surf.nc -o ${CONFCASE}_y${year}_std_grid${var}surf.nc

# Storing
mkdir -p $DIAGDIR/$year
#mv ${CONFCASE}_y${year}_mean_grid${var}surf.nc $DIAGDIR/$year
#mv ${CONFCASE}_y${year}_mean_grid${var}surf2.nc $DIAGDIR/$year
#mv ${CONFCASE}_y${year}_mean_grid${var}surf_minmax.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}_std_grid${var}surf.nc $DIAGDIR/$year
cd $WORKDIR/TMP_MEAN
rm -rf $year   # in order to erase tmp directory
done
