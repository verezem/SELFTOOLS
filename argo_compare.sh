#!/bin/bash

set -x

# This is a script to calculate timeseries of MLD in Labrador and Irminger Seas 
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi

# Set working dir
year=$1 # year is the first argument of the srpt 

# Calculation of yearly means with cdfmoy for transport, fresh water flux and sssth means in the files we have in diags dir
mkdir -p $WORKDIR/TMP$$
mkdir -p $DIAGDIR/${year}
cd $WORKDIR/TMP$$
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${GRID1}.nc ./
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${GRID2}.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

for tfile in ${CONFCASE}_y${year}m??*.${freq}_${GRID1}.nc ; do
   mxlf=$(echo $tfile | sed -e "s/gridTsurf/flxT/g")
   newt=$(echo $tfile | sed -e "s/gridTsurf/zoomT/g")
   news=$(echo $tfile | sed -e "s/gridTsurf/zoomS/g")
   newm=$(echo $tfile | sed -e "s/gridTsurf/zoomMLD/g")
   ncks -O -v votemper,vosaline,nav_lat,nav_lon $tfile tmp.nc
   cdfmean -f tmp.nc -v votemper -p T -w 202 293 150 220 1 55 -o $newt  
   cdfmean -f tmp.nc -v vosaline -p T -w 202 293 150 220 1 55 -o $news
   cdfmean -f $mxlf -v somxl010 -p T -w 202 293 150 220 0 0 -o $newm
   ncks -A -v mean_somxl010 $newm $newt
done

ncrcat -O ${CONFCASE}_y${year}m??*.${freq}_zoomT.nc ${DIAGDIR}/${year}/${CONFCASE}_y${year}_zoomT.nc  
ncrcat -O ${CONFCASE}_y${year}m??*.${freq}_zoomS.nc ${DIAGDIR}/${year}/${CONFCASE}_y${year}_zoomS.nc

cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

