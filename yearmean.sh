#!/bin/bash

#set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source ./header.sh
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) GO "
   echo " This script will compute the annular mean for all varibles in diags directory. Currently from 1992 to 2015. "
   exit
fi 

# Calculation of yearly means with cdfmoy for transport, fresh water flux and sssth means in the files we have in diags dir
mkdir -p $WORKDIR/TMP$$
cd $WORKDIR/TMP$$
for year in {1992..1995} ; do
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.5d_[Nn]orthtrp.nc -o ${CONFCASE}_y${year}_northtrp.nc 
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.5d_[Ss]outhtrp.nc -o ${CONFCASE}_y${year}_southtrp.nc 
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.5d_fwfl.nc -o ${CONFCASE}_y${year}_fwfl.nc 
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sshmean.nc -o ${CONFCASE}_y${year}_sshmean.nc
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sssmean.nc -o ${CONFCASE}_y${year}_sssmean.nc
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sstmean.nc -o ${CONFCASE}_y${year}_sstmean.nc
done

mkdir -p $DIAGDIR/1992-1995

# Concatenate them betwenn each other for the whole period of run
for typ in northtrp southtrp fwfl sshmean sssmean sstmean ; do
ncrcat ${CONFCASE}_y????_${typ}.nc $DIAGDIR/1993-2015/${CONFCASE}_y1991-1995_${typ}.nc
done

# Now concatenate map files with yarly means of T, U, V, EKE (Where is the salinity field??)
# Links to the workdir
for year in {1992..1995} ; do
#for var in eke mean_gridTsurf_minmax mean_gridTsurf mean_gridUsurf mean_gridVsurf std_gridTsurf ; do
for var in std_gridTsurf ; do
ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}_${var}.nc $WORKDIR/TMP$$
done 
done

# Concatenation
cd $WORKDIR/TMP$$
#for var in eke mean_gridTsurf_minmax mean_gridTsurf mean_gridUsurf mean_gridVsurf std_gridTsurf ; do
for var in std_gridTsurf ; do
ncrcat ${CONFCASE}_y????_${var}.nc $DIAGDIR/1992-1995/${CONFCASE}_y1992-1995_${var}.nc
done

cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

