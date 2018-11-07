#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate SSH over domain mean values, [m]
# Uses CDFTOOLSv4

source ./header_NNATLYS12.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Set working dir
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_MXL/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


#for var in T ; do
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_grid2D.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
cdfmoy -l ${CONFCASE}_y${year}m??*.${freq}_grid2D.nc -max -o ${CONFCASE}_y${year}_mgrid2D
cdfstd -l ${CONFCASE}_y${year}m??*.${freq}_grid2D.nc -o ${CONFCASE}_y${year}_sgrid2D.nc

# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}_mgrid2D.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}_mgrid2D_minmax.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}_sgrid2D.nc $DIAGDIR/$year
cd $WORKDIR/TMP_MXL
rm -rf $year   # in order to erase tmp directory
