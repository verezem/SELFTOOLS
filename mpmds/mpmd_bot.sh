#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=28
#SBATCH --threads-per-core=1
#SBATCH --constraint=BDW28
#SBATCH -J bot
#SBATCH -e zbot.e%j
#SBATCH -o zbot.o%j
#SBATCH --time=00:15:00
##SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

for y in {1993..2015} ; do
  cmd="$cmd -np 1 ./bot_sigma.sh $y :"
done
cmd=${cmd%:}
$cmd

