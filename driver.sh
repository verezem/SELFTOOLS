#!/bin/bash

sbatch ./mpmds/mpmd_trp.sh # transport
sbatch ./mpmds/mpmd_integrtr.sh # transport
sbatch ./mpmds/mpmd_sssth.sh # mean sss, ssh, sst timeseries
sbatch ./mpmds/mpmd_fwflx.sh # mean fresh water flux
sbatch ./mpmds/mpmd_curl.sh # concatenated curl over f 
#sbatch ./mpmds/mpmd_tsd.sh # Volumetric T-S diagrams
sbatch ./mpmds/mpmd_bot.sh # Bottom temperature and salinity
sbatch ./mpmds/mpmd_sig.sh # sigma
#sbatch ./mpmds/mpmd_pv.sh # potential vorticity
#sbatch ./mpmds/mpmd_sec.sh # AR7W, 60N, A24N, OVIDE sections
sbatch ./mpmds/mpmd_drft.sh # drifters style pic
#sbatch ./mpmds/mpmd_obsst.sh # observation-like extration of T, S 
sbatch ./mpmds/mpmd_mxl.sh #spat_mxl.sh 
sbatch ./mpmds/mpmd_ohc.sh #ocean heat content.sh 
# After all:
#sbatch ./mpmds/mpmd_spat.sh # mean spatial fields distribution
## After spat:
#sbatch ./mpmds/mpmd_eke.sh # EKE
#./mon_drift.sh # drift style compilation
