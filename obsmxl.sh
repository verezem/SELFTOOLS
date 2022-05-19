#!/bin/bash

set -x
ulimit -s unlimited

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
WRKDIR=$WORKDIR/TMP_OBS/$year
mkdir -p $WRKDIR # -p is to avoid mkdir if exists, and create a parent if needed
cd $WRKDIR
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)
mkdir -p $DIAGDIR/${year}

ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_grid[TS].nc ./
# Main body
# Temperature is initially daily - we need to average it monthly to get monthly 2D means
for mon in {01..12} ; do
cdfmxl -t ${CONFCASE}_y${year}m${mon}d15.1m_gridT.nc -s ${CONFCASE}_y${year}m${mon}d15.1m_gridS.nc -o ${CONFCASE}_y${year}m${mon}_mld.nc
done
ncrcat ${CONFCASE}_y${year}m??_mld.nc ${CONFCASE}_y${year}_mld.nc

mv ${CONFCASE}_y${year}_mld.nc $DIAGDIR/${year}/
cd $WORKDIR/TMP_OBS
rm -rf $year   # in order to erase tmp directory
