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
WRKDIR=$WORKDIR/TMP_MEAN/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


for var in $GRIDU $GRIDV $GRID1; do
#for var in T ; do
cd $WRKDIR
for mon in {06..07} ; do
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m${mon}*.${freq}_${var}.nc ./
done
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for lev in 1 $lev100 ; do
for fl in ${CONFCASE}_y${year}m*.${freq}_${var}.nc ; do
tmp=$( echo $(basename $fl) | awk -F_ '{ print $2}' )
if [ $var == 'gridT' ]
then
   dep=deptht
elif [ $var == 'gridU' ]
then
   dep=$depu
elif [ $var == 'gridV' ] 
then
   dep=$depv
fi
ncks -F -O -d ${dep},${lev} $fl ${CONFCASE}_${tmp}.l${lev}_${var}.nc
done
done
done
#for lev in 1 $lev1000 ; do
#for u in ${CONFCASE}_y${year}m??*.${freq}.l${lev}_gridU.nc ; do
#v=$(echo $u | sed -e "s/gridU/gridV/g")
#out=$(echo $u | sed -e "s/gridU/current/g")
#ncwa -O -a $depu $u $u
#ncwa -O -a $depv $v $v
#ncks -A -v vomecrty $v $u
#ncap2 -O -s "current=sqrt(vomecrty^2+vozocrtx^2)" $u $out
#done
#cdfmoy -l ${CONFCASE}_y${year}m??*.l${lev}_current.nc -o ${CONFCASE}_y${year}.l${lev}_current
#done

# Storing
mkdir -p $DIAGDIR/$year
for var in $GRID1 $GRIDS $GRIDU $GRIDV ; do
for lev in 1 $lev100 ; do
ncrcat ${CONFCASE}_*.l${lev}_${var}.nc $DIAGDIR/$year/${CONFCASE}_y${year}.l${lev}_${var}.nc
done
done

cd $WORKDIR/TMP_MEAN
rm -rf $year   # in order to erase tmp directory
