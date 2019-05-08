#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --ntasks-per-node=12
#SBATCH --threads-per-core=1
#SBATCH --constraint=HSW24
#SBATCH -J clim_sec
#SBATCH -e zsecc.e%j
#SBATCH -o zsecc.o%j
#SBATCH --time=00:15:00
##SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

for mon in {01..12} ; do
  cmd="$cmd -np 1 ./mon_clima.sh $mon :"
done
cmd=${cmd%:}
$cmd
