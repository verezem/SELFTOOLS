#!/bin/bash

set -x

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
WRKDIR=$WORKDIR/TMP_MEAN/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${GRID1}.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for t in ${CONFCASE}_y${year}m??*.${freq}_${GRID1}.nc ;
do
out=$(echo $t | sed -e "s/${GRID1}/sshmean/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
cdfmean -f $t -v $SSH -p T -o $out $extra
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat -O -h ${CONFCASE}_y${year}m??*.${freq}_sshmean.nc $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sshmean.nc  # ncrcat -h - is no history

cd $WORKDIR/TMP_MEAN
rm -rf $year   # in order to erase tmp directory
