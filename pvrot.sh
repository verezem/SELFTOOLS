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
WRKDIR=$WORKDIR/TMP_CURL/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_grid[TUV].nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for tfile in ${CONFCASE}_y${year}m??*.${freq}_gridT.nc ; do
   ufile=$(echo $tfile | sed -e "s/gridT/gridU/g")
   vfile=$(echo $tfile | sed -e "s/gridT/gridV/g")
   out=$(echo $tfile | sed -e "s/gridT/pvrot/g") 
   cdfpvor -t $tfile -u $ufile -v $vfile -o $out
done
exit
# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat *_pvrot.nc ${CONFCASE}_y${year}.${freq}_pvrot.nc
mv ${CONFCASE}_y${year}.${freq}_pvrot.nc $DIAGDIR/$year
cd $WORKDIR/TMP_CURL
rm -rf $year   # in order to erase tmp directory
