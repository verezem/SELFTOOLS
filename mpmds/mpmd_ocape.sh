#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=28
#SBATCH --threads-per-core=1
#SBATCH --constraint=BDW28
#SBATCH -J pv 
#SBATCH -e zpv.e%j
#SBATCH -o zpv.o%j
#SBATCH --time=0:10:00
##SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

for y in {1993..2015} ; do
  cmd="$cmd -np 1 ./ocape.sh $y :"
done
cmd=${cmd%:}
$cmd

