#!/bin/bash

set -x
ulimit -s unlimited

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

# path to workdir
WRKDIR=$WORKDIR/TMP_BOT/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed


cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_gridT.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for fl in ${CONFCASE}_y${year}m??*.${freq}_gridT.nc ; do
out=$(echo $fl | sed -e "s/gridT/botT/g")
cdfbottom -f $fl -p T -o $out
done
cdfmoy -l ${CONFCASE}_y${year}m??*.${freq}_botT.nc -o ${CONFCASE}_y${year}_botT

# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}_botT.nc $DIAGDIR/$year
cd $WORKDIR/TMP_BOT
rm -rf $year   # in order to erase tmp directory
