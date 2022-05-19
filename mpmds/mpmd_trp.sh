#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=28
#SBATCH --threads-per-core=1
#SBATCH --constraint=BDW28
#SBATCH -J trp_diag
#SBATCH -e ztrp.e%j
#SBATCH -o ztrp.o%j
#SBATCH --time=00:50:00
##SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

n=0
for y in {1993..2015} ; do
  cmd="$cmd -np 1 ./transport.sh $y :"
done
cmd=${cmd%:}
$cmd
