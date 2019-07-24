#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate monthly means and climatologies of mean sections 
# The idea is:
# cdf_xtract_brokenline
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
WRKDIR=$WORKDIR/TMP_SEC/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp ./sections/*.short.* $WRKDIR/
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m07d??.${freq}_*.nc ./  # link files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for mon in {07..07} ; do
    for day in {04..15} ; do
    if [ -z "$exsal" ]; then
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${day}*_${GRID1}.nc -u ${CONFCASE}_y${year}m${mon}d${day}*_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${day}*_${GRIDV}.nc -mxl ${CONFCASE}_y${year}m${mon}d${day}*_${GRID2}.nc -l 60N.short.dat -mld -vt -vecrot -o ${CONFCASE}_y${year}m${mon}d${day}_
    else
    exsal="-s ${CONFCASE}_y${year}m${mon}d${day}.1d_${GRIDS}.nc" 
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${day}*_${GRID1}.nc $exsal -u ${CONFCASE}_y${year}m${mon}d${day}*_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${day}*_${GRIDV}.nc -mxl ${CONFCASE}_y${year}m${mon}d${day}*_${GRID2}.nc -l 60N.short.dat -mld -vt -vecrot -o ${CONFCASE}_y${year}m${mon}d${day}_
    fi
    done
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
for sec in 60N ; do
#cdfmoy -l ${CONFCASE}_y${year}m*_${sec}.nc -o $DIAGDIR/${year}/${CONFCASE}_y${year}_${sec}ss  # ncrcat -h - is no history
ncrcat ${CONFCASE}_y${year}m*_${sec}.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_${sec}ss.nc  # 
done

cd $WORKDIR/TMP_SEC
rm -rf $year   # in order to erase tmp directory
