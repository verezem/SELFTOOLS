#!/bin/bash

set -x

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
lev=11 # for NNATLYS12 - 11

# path to workdir
WRKDIR=$WORKDIR/TMP_INT/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

ln -sf $SWDIR/$year/${CONFCASE}_y${year}m*.${freq}_${GRIDU}.nc ./
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m*.${freq}_${GRIDV}.nc ./
# Main body
for u in ${CONFCASE}_y${year}m??*.${freq}_gridU.nc ;
do
v=$(echo $u | sed -e "s/gridU/gridV/g")
u700=$(echo $u | sed -e "s/gridU/gridU700/g")
v700=$(echo $u | sed -e "s/gridU/gridV700/g")
ncks -F -O -d depthu,1,43 $u $u700
ncks -F -O -d depthv,1,43 $v $v700
#out=$(echo $u | sed -e "s/gridU/intr/g")
out700=$(echo $u | sed -e "s/gridU/intr700/g")
#cdfvtrp -u ${u} -v ${v} -o ${out}
cdfvtrp -u ${u700} -v ${v700} -o ${out700}
done

#cdfmoy -l ${CONFCASE}_y${year}m*.${freq}_intr.nc -o ${CONFCASE}_y${year}_intr
cdfmoy -l ${CONFCASE}_y${year}m*.${freq}_intr700.nc -o ${CONFCASE}_y${year}_intr700

# Storing
mkdir -p $DIAGDIR/$year
#mv ${CONFCASE}_y${year}_intr.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}_intr700.nc $DIAGDIR/$year
cd $WORKDIR/TMP_INT
rm -rf $year   # in order to erase tmp directory
