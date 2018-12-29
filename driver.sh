#!/bin/bash

#sbatch ./mpmd_trp.sh # transport
#sbatch ./mpmd_sssth.sh # mean sss, ssh, sst timeseries
#sbatch ./mpmd_fwflx.sh # mean fresh water flux
#sbatch ./mpmd_curl.sh # concatenated curl over f 
#sbatch ./mpmd_tsd.sh # Volumetric T-S diagrams
#sbatch ./mpmd_bot.sh # Bottom temperature and salinity
#sbatch ./mpmd_sig.sh # sigma
#sbatch ./mpmd_pv.sh # potential vorticity
#sbatch ./mpmd_sec.sh # AR7W, 60N, A24N, OVIDE sections
## After all:
sbatch ./mpmd_spat.sh # mean spatial fields distribution
sbatch ./mpmd_eke.sh # EKE
