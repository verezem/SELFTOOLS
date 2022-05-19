#!/bin/bash
# tricky way to make it parallel!
ulimit -s unlimited
set -x
n=0
for y in {1994..2015} ; do
  n=$(( n+1 ))
  ./denstsec.sh $y &
  #./integrtr.sh $y &
  if [ $n = 12 ] ; then
    wait
    n=0
  fi
done
wait
