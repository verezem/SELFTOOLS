#!/bin/bash

set -x
ulimit -s unlimited

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
WRKDIR=$WORKDIR/TMP_OBS/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cd $WRKDIR
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)
mkdir -p $DIAGDIR/${year}
for typ in $GRID1 $GRIDS ; do
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${typ}.nc ./
# We take only surface layer

for fl in ${CONFCASE}_y${year}m${mon}*.${freq}_${typ}.nc ; do
tmp=$( echo $(basename $fl) | awk -F_ '{ print $2}' )
ncks -F -O -d deptht,1 $fl ${CONFCASE}_${tmp}_0m${typ}.nc
done
done
# cdfmoy - for time averaging - we now have monthly means of 2d fields
for mon in {01..12} ; do
cdfmoy -l ${CONFCASE}_y${year}m${mon}*.${freq}_0m${GRID1}.nc -o ${CONFCASE}_y${year}m${mon}_0mvotemper
cdfmoy -l ${CONFCASE}_y${year}m${mon}*.${freq}_0m${GRIDS}.nc -o ${CONFCASE}_y${year}m${mon}_0mvosaline
done

# Main body
for var in $SST $SSS ; do
# cdfmean - we compute spatial means for each timestep
for mon in {01..12} ; do
cdfmean -f ${CONFCASE}_y${year}m${mon}_0m${var}.nc -v ${var} -p T -o ${CONFCASE}_y${year}m${mon}_0m${var}mean.nc
done
ncrcat ${CONFCASE}_y${year}m??_0m${var}mean.nc ${CONFCASE}_y${year}_0m${var}mean.nc
cdfmoy_weighted -l ${CONFCASE}_y${year}m??_0m${var}.nc -o ${CONFCASE}_y${year}_0m${var}.nc

mv ${CONFCASE}_y${year}m*_0m${var}.nc $DIAGDIR/${year}/
mv ${CONFCASE}_y${year}_0m${var}.nc $DIAGDIR/${year}/
mv ${CONFCASE}_y${year}_0m${var}mean.nc $DIAGDIR/${year}/
done
cd $WORKDIR/TMP_OBS
rm -rf $year   # in order to erase tmp directory
