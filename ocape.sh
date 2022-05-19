#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate ocean convective potential energy 
# The idea is:
# cdfocape
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh

# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year>"
   exit
fi

# Get year from screen
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_CAP/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m01d??.${freq}_${GRID1}.nc ./  # link files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

IRM="-w 349 557 146 318"
LAB="-w 81 345 98 399"
ARC="-w 431 893 316 399"

for mon in {01..01} ; do
for day in {04..09} ; do
    #cdfmoy -l ${CONFCASE}_y${year}m${mon}d*.${freq}_gridT.nc -o ${CONFCASE}_y${year}m${mon}_gridT
    cdfocape -dep 200 -t ${CONFCASE}_y${year}m${mon}d${day}.${freq}_${GRID1}.nc -o ${CONFCASE}_y${year}m${mon}d${day}_ATL_
    cdfocape -dep 700 -t ${CONFCASE}_y${year}m${mon}d${day}.${freq}_${GRID1}.nc -o ${CONFCASE}_y${year}m${mon}d${day}_ATL_
    cdfocape -dep 1500 -t ${CONFCASE}_y${year}m${mon}d${day}.${freq}_${GRID1}.nc -o ${CONFCASE}_y${year}m${mon}d${day}_ATL_
done
done

ncrcat -O -h ${CONFCASE}_y${year}m01*_ATL_ocape0200.nc $DIAGDIR/$year/${CONFCASE}_y${year}_ATL_ocape200.nc
ncrcat -O -h ${CONFCASE}_y${year}m01*_ATL_ocape0700.nc $DIAGDIR/$year/${CONFCASE}_y${year}_ATL_ocape700.nc
ncrcat -O -h ${CONFCASE}_y${year}m01*_ATL_ocape1500.nc $DIAGDIR/$year/${CONFCASE}_y${year}_ATL_ocape1500.nc

#ncrcat -O -h ${CONFCASE}_y${year}m*iocape0200.nc $DIAGDIR/$year/${CONFCASE}_y${year}_iocape200.nc
#ncrcat -O -h ${CONFCASE}_y${year}m*iocape0700.nc $DIAGDIR/$year/${CONFCASE}_y${year}_iocape700.nc
#ncrcat -O -h ${CONFCASE}_y${year}m*iocape1500.nc $DIAGDIR/$year/${CONFCASE}_y${year}_iocape1500.nc

cd $WORKDIR/TMP_CAP
#rm -rf $year   # in order to erase tmp directory
