#!/bin/ksh

if [ $# = 0 ] ; then
   echo " Usage : $(basename $0 ) <year> "
   exit 0
fi

cd /mnt/meom/workdir/molines/TMPDIR/GLORYS2V4/TRANSPORTS
year=$1
ln -sf /mnt/meom/MODEL_SET/GLORYS2V4/$year/GLORYS2V4_ORCA025_${year}??_grid[UV].nc ./ 

for u in GLORYS2V4_ORCA025_${year}??_gridU.nc ; do
    v=$( echo $u | sed -e "s/gridU/gridV/" )
    tmp=$( echo $u | awk -F_ '{print $3}' )
    echo $tmp
    tag=y${tmp:0:4}m${tmp:4:2}
    cdftransport -noheat -u $u -v $v -sfx ${tag}_transport < section.dat
    rm $u $v
done
 # concat

for zone in  Bosphorus Denmark Hudson North South ; do
    ncrcat -h ${zone}_y${year}m??_transport.nc ../${zone}_y${year}_transport.nc
    rm ${zone}*
done
