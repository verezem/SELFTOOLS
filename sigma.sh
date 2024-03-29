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
   echo " USAGE: $(basename $0) <year> <level>"
   exit
fi 

# Get year from screen
year=$1 # year is the first argument of the srpt
lev=0 # sigma is pressure dependant: specify the level

# path to workdir
WRKDIR=$WORKDIR/TMP_SIG/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp ./sections/*.short.* $WRKDIR/
cd $WRKDIR

cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for typ in $GRID1 $GRIDS ; do
    ln -sf $SWDIR4/$year/${CONFCASE}_y${year}m01d0[456789].${freq4}_${typ}.nc ./  # link files
done
for fl in ${CONFCASE}_y${year}m01d0[456789].${freq4}_${GRID1}.nc ; do
if [ -z "$exsal" ] ; then
    out=$(echo $fl | sed -e "s/$GRID1/sigma${lev}/g")  
    cdfsig0 -t $fl -sal sosaline -tem sosstsst -o $out
    #cdfsigntr -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc -o ${CONFCASE}_y${year}m${mon}_sigmantr.nc
else
    s=$(echo $fl | sed -e "s/$GRID1/$GRIDS/g")  
    out=$(echo $fl | sed -e "s/$GRID1/sigma${lev}/g")  
    cdfsigi -t $fl -r $lev -s $s -o $out 
fi
done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat -O -h ${CONFCASE}_y${year}m01*.${freq4}_sigma${lev}.nc $DIAGDIR/${year}/${CONFCASE}_y${year}m01_sigma${lev}.nc  # ncrcat -h - is no history
#ncrcat -O -h ${CONFCASE}_y${year}m??_sigmantr.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_sigmantr.nc  # ncrcat -h - is no history
cd $WORKDIR/TMP_SIG
rm -rf $year   # in order to erase tmp directory
