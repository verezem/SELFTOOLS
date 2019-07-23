#!/bin/bash

set -x

# This is a script to calculate SSH over domain mean values, [m]
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> <first layer>" 
   exit
fi 

# Set working dir
year=$1 # year is the first argument of the srpt
#fstl=$2 # fisrt layer to be processed
fstl=0 # fisrt layer to be processed
lstl=$3 # last layer to be processed


# path to workdir
WRKDIR=$WORKDIR/TMP_CURL/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
for dd in {04..15} ; do
ln -sf $SWDIR2/$year/${CONFCASE}_y${year}m07d${dd}.${freq2}_grid[UV].nc ./
done
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for dd in {04..15} ; do
   ufile=${CONFCASE}_y${year}m07d${dd}.${freq2}_gridU.nc
   vfile=$(echo $ufile | sed -e "s/gridU/gridV/g")
  out=$(echo $ufile | sed -e "s/gridU/curl/g") 
  cdfcurl -u $ufile vozocrtx -v $vfile vomecrty -overf -l ${fstl} -o $out
  #cdfcurl -u $ufile sozotaux -v $vfile sometauy -l ${fstl} -o $out
done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat *_curl.nc ${CONFCASE}_y${year}m07.${freq2}_curl.nc
ncrcat *_gridU.nc ${CONFCASE}_y${year}m07.${freq2}_gridU.nc
ncrcat *_gridV.nc ${CONFCASE}_y${year}m07.${freq2}_gridV.nc
mv ${CONFCASE}_y${year}m07.${freq2}_grid[UV].nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}m07.${freq2}_curl.nc $DIAGDIR/$year
cd $WORKDIR/TMP_CURL
rm -rf $year   # in order to erase tmp directory
