#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=28
#SBATCH --threads-per-core=1
#SBATCH --constraint=BDW28
#SBATCH -J eke_diag
#SBATCH -e zeke.e%j
#SBATCH -o zeke.o%j
#SBATCH --time=01:30:00
#SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

n=0
for y in {1993..2015} ; do
  cmd="$cmd -np 1 ./eke.sh $y :"
done
cmd=${cmd%:}
$cmd
