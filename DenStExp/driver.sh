#!/bin/bash

sbatch ./mpmd_trp.sh # transport
sbatch ./mpmd_tsd.sh # Volumetric T-S diagrams
sbatch ./mpmd_bot.sh # Bottom temperature and salinity
sbatch ./mpmd_sig.sh # sigma
sbatch ./mpmd_pv.sh # potential vorticity
# After sigma
#sbatch ./mpmd_sec.sh # DMS section
# After TS diag
#sbatch ./mpmd_sigtrp.sh # water transport in the special sigma range
