#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=24
#SBATCH --threads-per-core=1
#SBATCH --constraint=HSW24
#SBATCH -J trp_diag
#SBATCH -e ztrp.e%j
#SBATCH -o ztrp.o%j
#SBATCH --time=00:40:00
##SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

n=0
for y in {1992..2015} ; do
  cmd="$cmd -np 1 ./transport.sh $y :"
done
cmd=${cmd%:}
$cmd
