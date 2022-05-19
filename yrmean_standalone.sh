#!/bin/bash

#set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header.sh
#source /scratch/cnt0024/hmg2840/pverezem/DEV/SELFTOOLS/headers/header_CCI.sh

read -p "Enter the variable name :" var
 
# usage instructions
if [ $# = 0 ] ; then
   echo " USAGE: $(basename $0) variable_name "
   echo " This script will compute the annular mean for specified varible in diags directory. Currently from 1992 to 2015. "
   exit
fi 

# Calculation of yearly means with cdfmoy for exact files we have in diags dir
mkdir -p $WORKDIR/TMP$$
cd $WORKDIR/TMP$$
for year in {2002..2015} ; do
#for year in 2002 1994 1996 1997 1998 1999 2001 2002 2003 2004 2005 2006 2008 2009 2010 2011 2012 2013 2015 ; do
#ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}.1d_${var}.nc .
ln -sf $DIAGDIR/${year}/${CONFCASE}_y${year}_${var}.nc .
#cdfmoy -l ${CONFCASE}_y${year}_${var}.nc -o ${CONFCASE}_y${year}_${var}
done

mkdir -p $DIAGDIR/2002-2015

#ncrcat ${CONFCASE}_y????.1d_${var}.nc $DIAGDIR/2002-2015/${CONFCASE}_y2002-2015.1d_${var}.nc
ncrcat ${CONFCASE}_y????_${var}.nc $DIAGDIR/2002-2015/${CONFCASE}_y2002-2015_${var}.nc

cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

