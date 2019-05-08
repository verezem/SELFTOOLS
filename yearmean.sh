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
#for year in {1993..2015} ; do
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_[Nn]orthtrp.nc -o ${CONFCASE}_y${year}_northtrp.nc 
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_[Ss]outhtrp.nc -o ${CONFCASE}_y${year}_southtrp.nc 
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_fwfl.nc -o ${CONFCASE}_y${year}_fwfl.nc 
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sshmean.nc -o ${CONFCASE}_y${year}_sshmean.nc
#done
for year in {1992..2015} ; do
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sssmean.nc -o ${CONFCASE}_y${year}_sssmean.nc
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sshmean.nc -o ${CONFCASE}_y${year}_sshmean.nc
#cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_sstmean.nc -o ${CONFCASE}_y${year}_sstmean.nc
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}_NATLtsdiag.nc -o ${CONFCASE}_y${year}_Ntsdiag.nc
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}_LABtsdiag.nc -o ${CONFCASE}_y${year}_Ltsdiag.nc
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}_IRMtsdiag.nc -o ${CONFCASE}_y${year}_Itsdiag.nc
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}_ARCtsdiag.nc -o ${CONFCASE}_y${year}_Atsdiag.nc
cdfmoy_weighted -l $DIAGDIR/${year}/${CONFCASE}_y${year}_botT.nc -o ${CONFCASE}_y${year}_mbotT.nc
done

mkdir -p $DIAGDIR/1992-2015

# Concatenate them betwenn each other for the whole period of run
#for typ in northtrp southtrp fwfl sshmean ; do #sssmean sstmean ; do
#ncrcat -O ${CONFCASE}_y????_${typ}.nc $DIAGDIR/1993-2015/${CONFCASE}_y1993-2015_${typ}.nc
#done

mkdir -p $DIAGDIR/1992-2015
# Concatenate them betwenn each other for the whole period of run
for typ in Ntsdiag Itsdiag Ltsdiag Atsdiag mbotT ; do
#for typ in sshmean sssmean sstmean Ntsdiag mbotT ; do
#for typ in Ltsdiag Itsdiag Atsdiag ; do
ncrcat -O ${CONFCASE}_y????_${typ}.nc $DIAGDIR/1992-2015/${CONFCASE}_y1992-2015_${typ}.nc
done

# Now concatenate map files with yarly means of T, U, V, EKE (Where is the salinity field??)
# Links to the workdir
for year in {1992..2015} ; do
for lev in 1 47 ; do
for var in m${GRID1}_minmax m${GRID1} m${GRIDU} m${GRIDV} s${GRID1} current ; do
ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}.l${lev}_${var}.nc $WORKDIR/TMP$$
done 
done
ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}_eke.nc $WORKDIR/TMP$$
for sec in AR7W 60N A24N ovide ; do
ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}_${sec}.nc $WORKDIR/TMP$$
done
done

# Concatenation
cd $WORKDIR/TMP$$
for lev in 1 47 ; do
for var in  m${GRID1}_minmax m${GRID1} m${GRIDU} m${GRIDV} s${GRID1} current ; do
ncrcat -O ${CONFCASE}_y????.l${lev}_${var}.nc $DIAGDIR/1992-2015/${CONFCASE}_y1992-2015_${var}.l${lev}.nc
done
done
for sec in AR7W 60N A24N ovide ; do
ncrcat -O ${CONFCASE}_y????_${sec}.nc $DIAGDIR/1992-2015/${CONFCASE}_y1992-2015_${sec}.nc
done
ncrcat -O ${CONFCASE}_y????_eke.nc $DIAGDIR/1992-2015/${CONFCASE}_y1992-2015_eke.nc

cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory
