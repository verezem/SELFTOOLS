#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=24
#SBATCH --threads-per-core=1
#SBATCH --constraint=HSW24
#SBATCH -J curl_diag
#SBATCH -e zcurl.e%j
#SBATCH -o zcurl.o%j
#SBATCH --time=00:30:00
##SBATCH --dependency=singleton
#SBATCH --exclusive

#set -x

ulimit -s unlimited

cmd="mpirun --map-by node"

for y in {1993..2015} ; do
  cmd="$cmd -np 1 ../curl.sh $y 0 :"
done
cmd=${cmd%:}
$cmd
