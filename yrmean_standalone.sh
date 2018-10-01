#!/bin/bash

#set -x

# This is a script to calculate mean yearly values
# Uses CDFTOOLSv4

source ./header.sh

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
for year in {1992..2015} ; do
cdfmoy -l $DIAGDIR/${year}/${CONFCASE}_y${year}.${freq}_${var}.nc -o ${CONFCASE}_y${year}_${var}
done

mkdir -p $DIAGDIR/1992-2015

ncrcat ${CONFCASE}_y????_${var}.nc $DIAGDIR/1992-2015/${CONFCASE}_y1992-2015_${var}.nc

cd $WORKDIR
rm -rf TMP$$   # in order to erase tmp directory

