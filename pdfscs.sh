#!/bin/bash

set -x

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
WRKDIR=$WORKDIR/TMP_PDF/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
ln -sf $SWDIR2/$year/${CONFCASE}_y${year}m??*.${freq2}_grid[UV]surf.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

lev=1

# Main body
for u in ${CONFCASE}_y${year}m??*.${freq}_gridUsurf.nc ; do
v=$(echo $u | sed -e "s/gridUsurf/gridVsurf/g")
tmp=$( echo $(basename $u) | awk -F_ '{ print $2}' )
outu=${CONFCASE}_${tmp}.l${lev}_${GRIDU}.nc
outv=${CONFCASE}_${tmp}.l${lev}_${GRIDV}.nc
ncks -F -O -d ${dep},${lev} $u $outu
ncks -F -O -d ${dep},${lev} $v $outv
out=$(echo $u | sed -e "s/gridUsurf/current/g")
#ncwa -O -a $depu $u $u
#ncwa -O -a $depv $v $v
ncks -A -v vomecrty $v $u
scspdf=$(echo $u | sed -e "s/gridUsurf/pdfscs/g")
ncap2 -O -s "current=sqrt(vomecrty^2+vozocrtx^2)" $u $out
cdfpdf -f $out -v current -o $scspdf -range 0 2 120
done
cdfmoy -l ${CONFCASE}_y${year}m??*_pdfscs.nc -o ${CONFCASE}_y${year}_pdfscs

# Concatenation and storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}_pdfscs.nc $DIAGDIR/$year
cd $WORKDIR/TMP_PDF
rm -rf $year   # in order to erase tmp directory
