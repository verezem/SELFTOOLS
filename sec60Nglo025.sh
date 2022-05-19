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
cp ./sections/*.short.* $WRKDIR/
cd $WRKDIR
mon=08
ln -sf $IDIR/$year/${CONFCASE}_y${year}m0?.${freq}_*.nc ./  # link files
cp $IDIR/NNATL12_domain_cfg_v1.6.nc mesh_zgr.nc
cp $IDIR/NNATL12_domain_cfg_v1.6.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
cp /scratch/cnt0024/hmg2840/pverezem/NNATL12/NNATL12-MP4.21-S/1d/2014/NNATL12-MP4.21_y2014m08d31.1d_gridV.nc vfile.nc
cp /scratch/cnt0024/hmg2840/pverezem/NNATL12/NNATL12-MP4.21-S/1d/2014/NNATL12-MP4.21_y2014m08d31.1d_gridU.nc ufile.nc
# Main body
cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}.1m_${GRID1}.nc -u ufile.nc -v vfile.nc -l 60N.short.dat -o ${CONFCASE}_y${year}m${mon}_

# Concatenation and storing
mkdir -p $DIAGDIR/$year
sec=60N
mv ${CONFCASE}_y${year}m${mon}_${sec}.nc $DIAGDIR/${year}/${CONFCASE}_y${year}_${sec}ss  # ncrcat -h - is no history

cd $WORKDIR/TMP_SEC
rm -rf $year   # in order to erase tmp directory
