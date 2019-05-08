#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=24
#SBATCH --threads-per-core=1
#SBATCH --constraint=HSW24
#SBATCH -J drifters
#SBATCH -e zdrf.e%j
#SBATCH -o zdrf.o%j
#SBATCH --time=00:30:00
##SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

for y in {1992..2015} ; do
  cmd="$cmd -np 1 ./driftstyle.sh $y :"
done
cmd=${cmd%:}
$cmd

