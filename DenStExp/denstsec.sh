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
cp ./denst.dat $WRKDIR/
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_grid[UV].nc ./  # link files
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_gridTsurf.nc ./  # link files
ln -sf $DIAGDIR/$year/*sigma0.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for mon in {09..09} ; do
for dd in {01..31} ; do
    if [ -z "$exsal" ]; then
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l denst.dat -vt -vecrot -o ${CONFCASE}_y${year}m${mon}d${dd}_
    else
    exsal="-s ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDS}.nc" 
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc $exsal -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l denst.dat -vt -vecrot -o ${CONFCASE}_y${year}m${mon}d${dd}_
    fi
done
done
# And compute online 
for fl in ${CONFCASE}_y${year}*_DenSt.nc ; do
   tag=$(echo $fl | awk -F_ '{print $2}' ) # magic
   cdfsigtrp -brk ${fl} -smin 26 -smax 28.4 -nbins 24 -refdep 0 -section denst_sec.dat
   mv DenSt_trpsig.nc ${CONFCASE}_${tag}_DMS_trpsig.nc
   cdfsigtrp -brk ${fl} -smin -10 -smax 10 -nbins 20 -temp -section denst_sec.dat
   mv DenSt_trptemp.nc ${CONFCASE}_${tag}_DMS_trptem.nc
done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
#ncrcat -O -h ${CONFCASE}_y${year}m*_DenSt.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_DMS.nc  # ncrcat -h - is no history
ncrcat -O -h ${CONFCASE}_y${year}m*_DMS_trpsig.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_DMS_trpsig.nc
ncrcat -O -h ${CONFCASE}_y${year}m*_DMS_trptem.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_DMS_trptem.nc
cd $WORKDIR/TMP_SEC
#rm -rf $year   # in order to erase tmp directory
