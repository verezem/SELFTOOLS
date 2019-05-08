#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate monthly means and climatologies of mean sections 
# The idea is:
# cdf_xtract_brokenline
# Uses CDFTOOLSv4

source ./header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year>"
   exit
fi 

# Get year from screen
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_SEC/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp ./denst.dat $WRKDIR/
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_grid[TUV].nc ./  # link files
ln -sf $DIAGDIR/$year/*sigma0.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for mon in {01..12} ; do
for dd in {01..31} ; do
    if [ -z "$exsal" ]; then
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l denst.dat -vt -vecrot -xtra ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_sigma0.nc vosigmai -o ${CONFCASE}_y${year}m${mon}d${dd}_
    else
    exsal="-s ${CONFCASE}_y${year}m${mon}d${dd}_${GRIDS}.nc" 
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc $exsal -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l denst.dat -vt -vecrot -xtra ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_sigma0.nc vosigmai -o ${CONFCASE}_y${year}m${mon}d${dd}_
    fi
done
done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat -O -h ${CONFCASE}_y${year}m*_DenSt.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_DMS.nc  # ncrcat -h - is no history

cd $WORKDIR/TMP_SEC
#rm -rf $year   # in order to erase tmp directory
