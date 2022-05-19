#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate SSH over domain mean values, [m]
# Uses CDFTOOLSv4

#source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header_CCI.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Set working dir
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_ICE/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cd $WRKDIR
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)
mkdir -p $DIAGDIR/${year}
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${GRID3}.nc ./

# cdfmoy - for time averaging - we now have monthly means of 2d fields
for mon in {01..12} ; do
cdfmoy -l ${CONFCASE}_y${year}m${mon}*.${freq}_${GRID3}.nc -o ${CONFCASE}_y${year}m${mon}_${SIC}
done

ncrcat ${CONFCASE}_y${year}m??_${SIC}.nc ${CONFCASE}_y${year}_${SIC}.nc

for fl in ${CONFCASE}_y${year}m??_${SIC}.nc ; do
    out=$(echo $fl | sed -e "s/${SIC}/${SIC}mean/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
    cdfmean -f $fl -v ${SIC} -p T -o $out $extra
done
ncrcat ${CONFCASE}_y${year}m*_${SIC}mean.nc ${CONFCASE}_y${year}_${SIC}mean.nc

mv ${CONFCASE}_y${year}_${SIC}.nc $DIAGDIR/${year}/
mv ${CONFCASE}_y${year}_${SIC}mean.nc $DIAGDIR/${year}/

cd $WORKDIR/TMP_ICE
rm -rf $year   # in order to erase tmp directory
