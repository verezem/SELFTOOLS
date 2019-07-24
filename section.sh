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
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_*.nc ./  # link files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for mon in {01..12} ; do
    for typ in $GRID1 $GRIDS $GRID2 $GRIDU $GRIDV ; do
        cdfmoy -l ${CONFCASE}_y${year}m${mon}d??.${freq}_${typ}.nc -o ${CONFCASE}_y${year}m${mon}_${typ}
    done
    if [ -z "$exsal" ]; then
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc -u ${CONFCASE}_y${year}m${mon}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}_${GRIDV}.nc -mxl ${CONFCASE}_y${year}m${mon}_${GRID2}.nc -l AR7W.short.dat 60N.short.dat ovide.short.dat -mld -vt -vecrot -o ${CONFCASE}_y${year}m${mon}_
    else
    exsal="-s ${CONFCASE}_y${year}m${mon}_${GRIDS}.nc" 
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal -u ${CONFCASE}_y${year}m${mon}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}_${GRIDV}.nc -l AR7W.short.dat 60N.short.dat ovide.short.dat -vt -vecrot -o ${CONFCASE}_y${year}m${mon}_
    fi
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
for sec in AR7W 60N ovide	 ; do
#for sec in A24N ; do
ncrcat -O -h ${CONFCASE}_y${year}m??_${sec}.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_${sec}.nc  # ncrcat -h - is no history
done

cd $WORKDIR/TMP_SEC
rm -rf $year   # in order to erase tmp directory
