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
WRKDIR=$WORKDIR/TMP$$/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed

cd $WRKDIR
ln -sf $SWDIR2/$year/${CONFCASE}_y${year}m??*.${freq2}_${GRID1}surf.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for var in sss sst ssh ; do
    case $var in
    ( sss )
       for t in ${CONFCASE}_y${year}m??*.${freq2}_${GRID1}surf.nc ; do
          out=$(echo $t | sed -e "s/${GRID1}surf/${var}mean/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
          cdfmean -f $t -v sosaline -p T -o $out $extra
       done
     ;;
     ( sst )
       for t in ${CONFCASE}_y${year}m??*.${freq2}_${GRID1}surf.nc ; do
          out=$(echo $t | sed -e "s/${GRID1}surf/${var}mean/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
          cdfmean -f $t -v sosstsst -p T -o $out $extra
       done
     ;;
     ( ssh )
       for t in ${CONFCASE}_y${year}m??*.${freq2}_${GRID1}surf.nc ; do
          out=$(echo $t | sed -e "s/${GRID1}surf/${var}mean/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
          cdfmean -f $t -v sossheig -p T -o $out $extra
       done
     esac
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
for var in sss sst ssh ; do
ncrcat -O -h ${CONFCASE}_y${year}m??*.${freq2}_${var}mean.nc $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq2}_${var}mean.nc  # ncrcat -h - is no history
done

cd $WORKDIR
rm -rf ./TMP$$   # in order to erase tmp directory
