#!/bin/bash
# tricky way to make it parallel!
set -x
n=0
for y in {1992..2005} ; do
  n=$(( n+1 ))
  ./mean_fwflx.sh $y &
  if [ $n = 12 ] ; then
    wait
    n=0
  fi
done
wait
