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
WRKDIR=$WORKDIR/TMP_OBS/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cd $WRKDIR
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
mkdir -p $DIAGDIR/${year}
ln -sf $DIAGDIR/$year/${CONFCASE}_y${year}_sigma0.nc ./
# We take only surface layer
ncks -F -O -d deptht,1 ${CONFCASE}_y${year}_sigma0.nc ${CONFCASE}_y${year}_0mvosigma0.nc
# cdfmoy - for time averaging - we now have monthly means of 2d fields

# Main body
# cdfmean - we compute spatial means for each timestep
cdfmean -f ${CONFCASE}_y${year}_0mvosigma0.nc -v vosigmai -p T -o ${CONFCASE}_y${year}_0mvosigma0mean.nc

mv ${CONFCASE}_y${year}_0mvosigma0.nc $DIAGDIR/${year}/
mv ${CONFCASE}_y${year}_0mvosigma0mean.nc $DIAGDIR/${year}/
cd $WORKDIR/TMP_OBS
rm -rf $year   # in order to erase tmp directory
