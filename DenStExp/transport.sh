#!/bin/bash

set -x

# This is a script to calculate fresh water balance and fluxes
# The idea is:
# volume, heat and salt transports
# Uses CDFTOOLSv4

source ./header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Get year from screen
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_TRSP/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp $section_file $WRKDIR/$section_file
cd $WRKDIR
for var in ${GRID1} ${GRIDU} ${GRIDV} ; do
for mon in {07..07} ; do
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m${mon}*.${freq}_${var}.nc ./  # read flux files
done
done
#ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_grid[TSUV].nc ./  # read flux files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for u in ${CONFCASE}_y${year}m${mon}*.${freq}_gridU.nc ;
do
v=$(echo $u | sed -e "s/gridU/gridV/g")
t=$(echo $u | sed -e "s/gridU/gridTsurf/g")
s=$(echo $u | sed -e "s/gridU/gridTsurf/g")
cdftransport -u $u -v $v -t $t -TS < section.dat
cdfsigtrp -t $t -u $u -v $v -smin 28.02 -smax 28.08 -nbins 1 -refdep 1000 -section section.dat
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
#ncrcat -O -h ${sec}_y${year}m??*.${freq}_transport.nc $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_${sec}trp.nc  # ncrcat -h - is no history
#cd $WORKDIR/TMP_TRSP
#rm -rf $year   # in order to erase tmp directory
