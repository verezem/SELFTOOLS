#!/bin/bash
# tricky way to make it parallel!
ulimit -s unlimited
set -x
n=0
for y in {1993..2015} ; do
  n=$(( n+1 ))
  #./spat_mean_var.sh $y  &
  #./mean_sssth.sh $y &
  #./eke.sh $y &
  ./obsurfdiag.sh $y &
  #./mean_fwflx.sh $y &
  #./mon_spat.sh $y &
  #./section.sh $y &
  #./voltsdiag.sh $y &
  if [ $n = 12 ] ; then
    wait
    n=0
  fi
done
wait
