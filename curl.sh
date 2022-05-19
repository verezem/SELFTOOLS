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

ln -sf $SWDIR2/$year/${CONFCASE}_y${year}m??*.${freq}_grid[UV].nc ./
#for day in {04..10} ; do
#ln -sf $SWDIR4/$year/${CONFCASE}_y${year}m01d${day}.${freq4}_grid[UV]surf.nc ./
#done
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for ufile in ${CONFCASE}_y${year}m01d*.${freq}_gridU.nc ; do
   vfile=$(echo $ufile | sed -e "s/gridU/gridV/g")
   out=$(echo $ufile | sed -e "s/gridU/curl/g") 
   out2=$(echo $ufile | sed -e "s/gridU/taucurl/g") 
   #cdfcurl -u $ufile vozocrtx -v $vfile vomecrty -overf -surf -o $out 
   cdfcurl -u $ufile vozo10m -v $vfile vome10m -overf -surf -o $out
   cdfcurl -u $ufile sozotaux -v $vfile sometauy -surf -o $out2
done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat *_curl.nc ${CONFCASE}_y${year}.${freq4}_curl.nc
ncrcat *_taucurl.nc ${CONFCASE}_y${year}.${freq4}_taucurl.nc
mv ${CONFCASE}_y${year}.${freq4}_curl.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}.${freq4}_taucurl.nc $DIAGDIR/$year
cd $WORKDIR/TMP_CURL
rm -rf $year   # in order to erase tmp directory
