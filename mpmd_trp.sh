#!/bin/bash
#SBATCH -p test
#SBATCH --ntasks=12
#SBATCH -J trp_diag
#SBATCH -e ztrp.e%j
#SBATCH -o ztrp.o%j
#SBATCH --time=00:15:00

#set -x

cmd="mpirun"

n=0
for y in {1993..2005} ; do
  cmd="$cmd -np 1 ./transport.sh $y :"
done
cmd=${cmd%:}
$cmd
