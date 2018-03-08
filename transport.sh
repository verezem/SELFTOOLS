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
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_grid[TUV].nc ./  # read flux files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

# Main body
for u in ${CONFCASE}_y${year}m??*.${freq}_gridU.nc ;
do
v=$(echo $u | sed -e "s/gridU/gridV/g")
t=$(echo $u | sed -e "s/gridU/gridT/g")
out=$(echo $u | sed -e "s/$GRID/fwfl/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
tag=$(echo $u | awk -F_ '{print $2}' ) # magic
namesec=$(head -1 $section_file)
sfx=${tag}_transport
if [ ! -f ${namesec}_${sfx}.nc ] ; then
cdftransport -u $u -v $v -t $t -TS -sfx $sfx < $section_file
fi
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
for sec in $(cat $section_file | awk '{ if ( NR%2 == 1 ) print $0 }') ; do
if [ $sec != EOF ] ; then
ncrcat -O -h ${sec}_y${year}m??*.${freq}_transport.nc $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_${sec}trp.nc  # ncrcat -h - is no history
fi
done
cd $WORKDIR/TMP_MEAN
rm -rf $year   # in order to erase tmp directory
