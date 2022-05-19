#!/bin/bash

set -x

# This is a script to calculate monthly means for volumetric diagrams computation 
# The idea is:
# cdfcensus
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year> "
   exit
fi 

# Get year from screen
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP$$/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp ./sections/*.short.* $WRKDIR/
cd $WRKDIR
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_*.nc ./  # link files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc

LAB="-zoom 45 345 120 399"
IRM="-zoom 345 885 207 399"
ARC="-zoom 443 803 266 399"

# Main body
for mon in {01..12} ; do
    for typ in $GRID1 $GRIDS ; do
        cdfmoy -l ${CONFCASE}_y${year}m${mon}d??.${freq}_${typ}.nc -o ${CONFCASE}_y${year}m${mon}_${typ}
    done
    #exsal="-s ${CONFCASE}_y${year}m${mon}_${GRIDS}.nc"
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal $LAB -klim 0 55 -srange 33 36.0 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_LABts2000.nc 
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal $IRM -klim 0 55 -srange 33 36.0 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_IRMts2000.nc 
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal $ARC -klim 0 55 -srange 33 36.0 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_ARCts2000.nc 
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal -klim 0 55 -srange 33 36 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_NATLts2000.nc 
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal $LAB -klim 55 75 -srange 33 36.0 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_LABtsbot.nc
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal $IRM -klim 55 75 -srange 33 36.0 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_IRMtsbot.nc  
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal $ARC -klim 55 75 -srange 33 36.0 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_ARCtsbot.nc  
    cdfcensus -t ${CONFCASE}_y${year}m${mon}_${GRID1}.nc $exsal -klim 55 75 -srange 33 36 0.01 -trange -2 18 0.05 -o ${CONFCASE}_y${year}m${mon}_NATLtsbot.nc
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
for reg in NATL LAB IRM ARC ; do
#for reg in NATL ; do
ncrcat -O -h ${CONFCASE}_y${year}m??_${reg}ts2000.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_${reg}ts2000.nc  # ncrcat -h - is no history
ncrcat -O -h ${CONFCASE}_y${year}m??_${reg}tsbot.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_${reg}tsbot.nc  # ncrcat -h - is no history
done

cd $WORKDIR
rm -rf ./TMP$$   # in order to erase tmp directory
