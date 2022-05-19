#!/bin/bash
# tricky way to make it parallel!
ulimit -s unlimited
set -x
n=0
for y in {1993..2015} ; do
  n=$(( n+1 ))
  #./fwflx.sh $y &
  #./section.sh $y &
  #./spat_mean_var.sh $y &
  #./obsmxl.sh $y &
  #./volktsdiag.sh $y &
  #./integrtr.sh $y &
  #./gli0XX.sh $y &
  #./eke.sh $y &
  #./bot_sigma.sh $y &
  ./amoc.sh $y &
  if [ $n = 12 ] ; then
    wait
    n=0
  fi
done
wait
