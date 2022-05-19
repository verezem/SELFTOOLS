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
cp ./sections/*.short.dat $WRKDIR/
cd $WRKDIR

for grid in $GRID1 $GRIDS $GRIDU $GRIDV ; do
    ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_${grid}.nc ./  # link files
done
for grid in $GRID1 $GRIDS $GRIDU $GRIDV ; do
    cdfmoy -l ${CONFCASE}_y${year}m??*.${freq}_${grid}.nc -o ${CONFCASE}_y${year}_m${grid}
done

sec=den2
echo $sec

cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body

if [ -z "$exsal" ]; then
cdf_xtrac_brokenline -t ${CONFCASE}_y${year}_m${GRID1}.nc -u ${CONFCASE}_y${year}_m${GRIDU}.nc -v ${CONFCASE}_y${year}_m${GRIDV}.nc -l ${sec}.short.dat -vt -vecrot  -o ${CONFCASE}_y${year}_
else
exsal="-s ${CONFCASE}_y${year}_m${GRIDS}.nc" 
cdf_xtrac_brokenline -t ${CONFCASE}_y${year}_m${GRID1}.nc $exsal -u ${CONFCASE}_y${year}_m${GRIDU}.nc -v ${CONFCASE}_y${year}_m${GRIDV}.nc -l ${sec}.short.dat -vt -vecrot -o ${CONFCASE}_y${year}_
fi


# Concatenation and storing
mkdir -p $DIAGDIR/$year
cp ${CONFCASE}_y${year}_Sill.nc $DIAGDIR/${year}/

cd $WORKDIR/TMP_SEC
rm -rf $year   # in order to erase tmp directory
