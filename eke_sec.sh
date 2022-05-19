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
WRKDIR=$WORKDIR/TMP_EKE/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cp ./sections/*.short.dat $WRKDIR/

cd $WRKDIR
for var in $GRID1 $GRIDU $GRIDV ; do
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??d??.${freq}_${var}.nc ./  # link files 
done

cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
cp $IDIR/${CONFIG}_domain_cfg_v1.6_locs.nc domain_cfg.nc

sec=den2
# Frist create sections over 1 year
for mon in {01..12} ; do
for dd in {01..31} ; do
    cdf_xtrac_brokenline -t ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRID1}.nc -u ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDU}.nc -v ${CONFCASE}_y${year}m${mon}d${dd}.${freq}_${GRIDV}.nc -l ${sec}.short.dat -vt -vecrot -xtra domain_cfg.nc gdept_0 -o ${CONFCASE}_y${year}m${mon}d${dd}_
done
done
# Now compute mean and mean2
cdfmoy -l ${CONFCASE}_y${year}m??d??_Sill.nc -o ${CONFCASE}_y${year}_mSill 
# Now compute eke from this sections 

cdfeke -u ${CONFCASE}_y${year}_mSill.nc -u2 ${CONFCASE}_y${year}_mSill2.nc -v ${CONFCASE}_y${year}_mSill.nc -v2 ${CONFCASE}_y${year}_mSill2.nc -t ${CONFCASE}_y${year}_mSill.nc -mke -o ${CONFCASE}_y${year}_Sill_eke.nc 
 
# Storing
mkdir -p $DIAGDIR/$year
mv ${CONFCASE}_y${year}_Sill_eke.nc $DIAGDIR/$year
cd $WORKDIR/TMP_EKE
#rm -rf $year   # in order to erase tmp directory
