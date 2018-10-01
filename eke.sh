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
WRKDIR=$WORKDIR/TMP_EKE/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


cd $WRKDIR
for var in T U V ; do
ln -sf $DIAGDIR/$year/${CONFCASE}_y${year}_mean_grid${var}surf2.nc ./
ln -sf $DIAGDIR/$year/${CONFCASE}_y${year}_mean_grid${var}surf.nc ./
done

cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body

cdfeke -u ${CONFCASE}_y${year}_mean_gridUsurf.nc -u2 ${CONFCASE}_y${year}_mean_gridUsurf2.nc -v ${CONFCASE}_y${year}_mean_gridVsurf.nc -v2 ${CONFCASE}_y${year}_mean_gridVsurf2.nc -t ${CONFCASE}_y${year}_mean_gridTsurf2.nc -surf -mke -o ${CONFCASE}_y${year}_eke.nc 
 
# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}_eke.nc $DIAGDIR/$year
cd $WORKDIR/TMP_EKE
#rm -rf $year   # in order to erase tmp directory
