#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate monthly means of AMOC
# The idea is:
# cdfmoc
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
WRKDIR=$WORKDIR/TMP_MOC/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cd $WRKDIR

cp $IDIR/${CONFIG}_domain_cfg_v1.6_locs.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_domain_cfg_v1.6_locs.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for typ in $GRIDV $GRID1 ; do
    ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_${typ}.nc ./  # link files
done

for mon in {01..12} ; do
    cdfmoy -l ${CONFCASE}_y${year}m${mon}d??.${freq}_${GRID1}.nc -o ${CONFCASE}_y${year}m${mon}_${GRID1}
    cdfmoy -l ${CONFCASE}_y${year}m${mon}d??.${freq}_${GRIDV}.nc -o ${CONFCASE}_y${year}m${mon}_${GRIDV}
    cdfmocsig -v ${CONFCASE}_y${year}m${mon}_${GRIDV}.nc -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc -r 2000 -o ${CONFCASE}_y${year}m${mon}_smoc.nc
    #cdfmoc -v ${CONFCASE}_y${year}m${mon}_${typ}.nc -o ${CONFCASE}_y${year}m${mon}_zmoc.nc
done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
#ncrcat -O -h ${CONFCASE}_y${year}m*_zmoc.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_zmoc.nc  # ncrcat -h - is no history
ncrcat -O -h ${CONFCASE}_y${year}m*_smoc.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_smoc.nc  # ncrcat -h - is no history
cd $WORKDIR/TMP_MOC
#rm -rf $year   # in order to erase tmp directory
