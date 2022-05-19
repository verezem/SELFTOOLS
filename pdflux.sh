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
ln -sf $SWDIR2/$year/${CONFCASE}_y${year}m??*.${freq2}_${GRID1}.nc ./
#ln -sf $SWDIR2/$year/${CONFCASE}_y${year}m??*.${freq2}_${GRID2}.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for mon in {01..12} ; do
   for day in {01..31} ; do
       cdfheatc2d -f ${CONFCASE}_y${year}m${mon}d${day}.${freq2}_${GRID1}.nc -zoom 160 295 142 260 0 75 -mxloption 1 -o ${CONFCASE}_y${year}m${mon}d${day}_mldhcl -map
       cdfheatc2d -f ${CONFCASE}_y${year}m${mon}d${day}.${freq2}_${GRID1}.nc -zoom 349 426 160 230 0 75 -mxloption 1 -o ${CONFCASE}_y${year}m${mon}d${day}_mldhci -map
   done
done

#for tfile in ${CONFCASE}_y${year}m??*.${freq2}_${GRID1}.nc ; do
#   mldhcl=$(echo $tfile | sed -e "s/gridTsurf/mldhc_L/g")
#   mldhci=$(echo $tfile | sed -e "s/gridTsurf/mldhc_I/g")
#   cdfheatc2d -f $tfile -zoom 195 291 150 260 0 0 -mxloption 1 -o $mldhcl -map
#   cdfheatc2d -f $tfile -zoom 349 426 160 230 0 0 -mxloption 1 -o $mldhci -map
#   pdfhcl=$(echo $tfile | sed -e "s/gridTsurf/pdfmldhcl/g")
#   pdfhci=$(echo $tfile | sed -e "s/gridTsurf/pdfmldhci/g")
#   cdfpdf -f $mldhcl -v heatc3d -o pdfhcl -range  
#   shfile=$(echo $tfile | sed -e "s/flxT/pdfshf/g")
#   lhfile=$(echo $tfile | sed -e "s/flxT/pdflhf/g") 
#   mlfile=$(echo $tfile | sed -e "s/flxT/pdfmld/g") 
#   cdfpdf -f $tfile -v $LHF -o $lhfile -range -1000 0 250
#   cdfpdf -f $tfile -v $SHF -o $shfile -range -1000 0 250
#   cdfpdf -f $tfile -v $MXL10 -o $mlfile -range 0 2500 250
#done
# Concatenation and storing
mkdir -p $DIAGDIR/$year
#ncrcat *_pdfshf.nc ${CONFCASE}_y${year}_pdfshf.nc
#ncrcat *_pdflhf.nc ${CONFCASE}_y${year}_pdflhf.nc
#ncrcat *_pdfmld.nc ${CONFCASE}_y${year}_pdfmld.nc
ncrcat *mldhclmap.nc ${CONFCASE}_y${year}_mldhcl.nc
ncrcat *mldhcimap.nc ${CONFCASE}_y${year}_mldhci.nc
#mv ${CONFCASE}_y${year}_pdfshf.nc $DIAGDIR/$year
#mv ${CONFCASE}_y${year}_pdflhf.nc $DIAGDIR/$year
#mv ${CONFCASE}_y${year}_pdfmld.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}_mldhcl.nc $DIAGDIR/$year
mv ${CONFCASE}_y${year}_mldhci.nc $DIAGDIR/$year
cd $WORKDIR/TMP_PDF
rm -rf $year   # in order to erase tmp directory
