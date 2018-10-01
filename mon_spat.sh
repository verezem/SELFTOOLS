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

cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m03*.${freq}_${GRID2}.nc ./
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m03*.${freq}_${GRID3}.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
cdfmoy -l ${CONFCASE}_y${year}m03*.${freq}_${GRID3}.nc -o ${CONFCASE}_y${year}m03.${freq}_${GRID3}
ncks -v siconc,nav_lat,nav_lon ${CONFCASE}_y${year}m03.${freq}_${GRID3}.nc ${CONFCASE}_y${year}m03_siconc.nc
cdfmoy -l ${CONFCASE}_y${year}m03*.${freq}_${GRID2}.nc -o ${CONFCASE}_y${year}m03.${freq}_${GRID2}
ncks -v sohefldo,solhflup,sosbhfup,nav_lat,nav_lon ${CONFCASE}_y${year}m03.${freq}_${GRID2}.nc ${CONFCASE}_y${year}m03_netflux.nc


# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}m03_siconc.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}m03_netflux.nc $DIAGDIR/$year
cd $WORKDIR/TMP_MEAN
rm -rf $year   # in order to erase tmp directory
