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
WRKDIR=$WORKDIR/TMP_MEAN/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


#for var in $GRIDU $GRIDV $GRID1; do
#for var in T ; do
for var in gridU gridV ; do
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${var}.nc ./
done
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/mesh_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

cdfmoy -l ${CONFCASE}_y${year}m??*.${freq}_gridU.nc -o ${CONFCASE}_y${year}_gridU
cdfmoy -l ${CONFCASE}_y${year}m??*.${freq}_gridV.nc -o ${CONFCASE}_y${year}_gridV

# Main body
for lev in 1 19 40 47 51 55 57 ; do
u=${CONFCASE}_y${year}_gridU.nc
v=$(echo $u | sed -e "s/gridU/gridV/g")

ulev=${CONFCASE}_y${year}.l${lev}_gridU.nc
vlev=${CONFCASE}_y${year}.l${lev}_gridV.nc

ncks -F -O -d depthu,${lev} $u $ulev
ncks -F -O -d depthv,${lev} $v $vlev

out=$(echo $ulev | sed -e "s/gridU/current/g")

ncwa -O -a $depu $ulev $ulev
ncwa -O -a $depv $vlev $vlev
ncks -A -v vomecrty $vlev $ulev
ncap2 -O -s "current=sqrt(vomecrty^2+vozocrtx^2)" $ulev $out
done

# Storing
mkdir -p $DIAGDIR/$year
for lev in 1 19 40 47 51 55 57 ; do
mv ${CONFCASE}_y${year}.l${lev}_current.nc $DIAGDIR/$year
done
cd $WORKDIR/TMP_MEAN
rm -rf $year   # in order to erase tmp directory
