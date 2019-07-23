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
WRKDIR=$WORKDIR/TMP_PV/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
for typ in $GRID1 $GRIDS $GRIDU $GRIDV ; do
for mon in {06..07} ; do
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m${mon}*.${freq}_${typ}.nc ./
done
done
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for tfile in ${CONFCASE}_y${year}m??*.${freq}_${GRID1}.nc ; do
if [ -z "$exsal" ] ; then
   ufile=$(echo $tfile | sed -e "s/${GRID1}/gridU/g")
   vfile=$(echo $tfile | sed -e "s/${GRID1}/gridV/g")
   out=$(echo $tfile | sed -e "s/${GRID1}/pvrot/g") 
   cdfpvor -t $tfile -u $ufile -v $vfile -o $out
else
   ufile=$(echo $tfile | sed -e "s/${GRID1}/gridU/g")
   vfile=$(echo $tfile | sed -e "s/${GRID1}/gridV/g")
   sfile=$(echo $tfile | sed -e "s/${GRID1}/${GRIDS}/g")
   out=$(echo $tfile | sed -e "s/${GRID1}/pvrot/g")
   cdfpvor -t $tfile -u $ufile -v $vfile -o $out
fi
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}m*_pvrot.nc $DIAGDIR/${year}/ # ncrcat -h - is no history
cd $WORKDIR/TMP_PV
rm -rf $year   # in order to erase tmp directory
