#!/bin/bash

set -x

# This is a script to calculate fresh water balance and fluxes
# The idea is:
# sowaflup = evaporation - precipitation - runoff + damping
# What is done here is:
# 1) From latent heat flux we get evaporation by dividing by Lv [kg/m2/s].
# 2) From accumulated precip we've got daily means by dividing by 86400 s [kg/m2/s]. 
# 3) Make a three-dimensional integration over the surface (assuming that 1st layer depth is 1m) [kg/s]. 
# Uses CDFTOOLSv4

# lv=2.5e6 - latent heat of vaporization [J/kg] or [m2/s2]
# ts=86400 - number of seconds per day 

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
ln -sf $SWDIR/$year/${CONFCASE}_y${year}m??*.${freq}_${GRID2}.nc ./  # read flux files
cp $IDIR/${CONFIG}_mesh_zgr.nc mesh_zgr.nc
cp $IDIR/${CONFIG}_mesh_hgr.nc mesh_hgr.nc
cp $IDIR/${CONFIG}_byte_mask.nc mask.nc
$cmdcp # command set in header for extra copy (mask file f.ex.)

# Main body
for flxin in ${CONFCASE}_y${year}m??*.${freq}_${GRID2}.nc ;
do
ncap2 -O -s "soevap=$LHF/${lv}" -s "soprecip=$PRECIP/${ts}" $flxin ztmpflx.nc
out=$(echo $flxin | sed -e "s/$GRID2/fwfl/g")  # !! Were are setting a new variable name using the name of initial one using a "serial editor"
for var in sowaflup soevap soprecip $RNF $DAMP ;
do
cdfsum -v $var -f ztmpflx.nc -p T -o ${var}.nc $extra
if [ $var = sowaflup ] ; then
cp $var.nc $out
else
ncks -A -v sum_3D${var} $var.nc $out
fi
done
done

# Concatenation and storing
mkdir -p $DIAGDIR/$year
ncrcat -h -O ${CONFCASE}_y${year}m??*.${freq}_fwfl.nc $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_fwfl.nc  # ncrcat -h - is no history

cd $WORKDIR
rm -rf ./TMP$$   # in order to erase tmp directory
