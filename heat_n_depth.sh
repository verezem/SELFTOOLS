#!/bin/bash

set -x

# This is a script to calculate SSH over domain mean values, [m]
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year>" 
   exit
fi 

# Set working dir
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_DEP/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${GRID2}.nc ./
#ln -sf $SWDIR/$year/${CONFCASE}_y${year}m03*.${freq}_${GRID2}.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for flx in ${CONFCASE}_y${year}m*.${freq}_${GRID2}.nc ; do
#for flx in ${CONFCASE}_y${year}m03*.${freq}_${GRID2}.nc ; do
   out=$(echo $flx | sed -e "s/$GRID2/depflx/g") 
   ncks -v somxl010,sohefldo,$LHF,$SHF,nav_lat,nav_lon $flx $out
done
for mon in {01..12} ; do
    cdfmoy -l ${CONFCASE}_y${year}m${mon}d??.${freq}_depflx.nc -o ${CONFCASE}_y${year}m${mon}_depflx
done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat ${CONFCASE}_y${year}m??_depflx.nc ${CONFCASE}_y${year}_depflx.nc
mv ${CONFCASE}_y${year}_depflx.nc $DIAGDIR/$year
cd $WORKDIR/TMP_DEP
rm -rf $year   # in order to erase tmp directory
