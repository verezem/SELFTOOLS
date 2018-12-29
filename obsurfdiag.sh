#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate SSH over domain mean values, [m]
# Uses CDFTOOLSv4

source ./header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Set working dir
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_OBS/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cd $WRKDIR
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)
mkdir -p $DIAGDIR/${year}

ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${GRID1}.nc ./
# Main body
# Temperature is initially daily - we need to average it monthly to get monthly 2D means
for mon in {01..12} ; do
cdfmoy -l ${CONFCASE}_y${year}m${mon}*.${freq}_${GRID1}.nc -o ${CONFCASE}_y${year}m${mon}_${var}
done
cdfmoy -l ${CONFCASE}_y${year}m${mon}_${var}.nc -o ${CONFCASE}_y${year}_${var}

# both temperature and salinity needs to be averaged spatially with cdfmean
# any of them are averaged daily or mothly initially
#for fl in ${CONFCASE}_y${year}m*.${freq}_${GRID1}.nc ; do
for fl in ${CONFCASE}_y${year}m??_${var}.nc ; do
    out=$(echo $fl | sed -e "s/${var}/${var}mean/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
    cdfmean -f $fl -v ${var} -p T -o $out $extra
done
ncrcat ${CONFCASE}_y${year}m*_${var}mean.nc ${CONFCASE}_y${year}_${var}mean.nc

mv ${CONFCASE}_y${year}m*_${var}.nc $DIAGDIR/${year}/
mv ${CONFCASE}_y${year}_${var}.nc $DIAGDIR/${year}/
mv ${CONFCASE}_y${year}_${var}mean.nc $DIAGDIR/${year}/
cd $WORKDIR/TMP_OBS
rm -rf $year   # in order to erase tmp directory
