#!/bin/bash

set -x
ulimit -s unlimited

# This is a script to calculate monthly means and climatologies of mean sections 
# The idea is:
# cdf_xtract_brokenline
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) <year>"
   exit
fi 

# Get year from screen
year=$1 # year is the first argument of the srpt

# path to workdir
WRKDIR=$WORKDIR/TMP_SEC/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp ./sections/*.short.dat $WRKDIR/
cd $WRKDIR
mon=07
for grid in $GRID1 $GRIDU $GRIDV ; do
    ln -sf $SWDIR/$year/${CONFCASE}_y${year}m${mon}d??.${freq}_${grid}.nc ./  # link files
done
#ln -sf $DIAGDIR/$year/*sigma0.nc ./
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
cp $IDIR/${CONFIG}_domain_cfg_v1.6_locs.nc domain_cfg.nc

# Main body
for dd in {01..31} ; do
    for sec in den1 ; do
    if [ -z "$exsal" ]; then
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l ${sec}.short.dat -vt -vecrot -xtra domain_cfg.nc gdept_0 -o ${CONFCASE}_y${year}m${mon}d${dd}_
    else
    exsal="-s ${CONFCASE}_y${year}m${mon}d${dd}_${GRIDS}.nc" 
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc $exsal -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l den${sec}.short.dat -vt -vecrot -o ${CONFCASE}_y${year}m${mon}d${dd}_
    fi
    done
done

#mon=06
#for dd in {01..12} ; do
#    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l den1.short.dat den2.short.dat den3.short.dat den4.short.dat den5.short.dat den6.short.dat -vt -vecrot -xtra domain_cfg.nc gdept_0 -o ${CONFCASE}_y${year}m${mon}d${dd}_
#done

ncrcat ${CONFCASE}_y${year}m${mon}d??_BtS.nc ${CONFCASE}_y${year}m${mon}_BtS.nc

# Concatenation and storing
mkdir -p $DIAGDIR/$year
cp ${CONFCASE}_y${year}m${mon}_BtS.nc $DIAGDIR/${year}/

cd $WORKDIR/TMP_SEC
rm -rf $year   # in order to erase tmp directory
