#!/bin/bash
# tricky way to make it parallel!
ulimit -s unlimited
set -x
n=0
for y in {1992..2014} ; do
  n=$(( n+1 ))
  ./mean_ssh.sh $y &
  if [ $n = 12 ] ; then
    wait
    n=0
  fi
done
wait
