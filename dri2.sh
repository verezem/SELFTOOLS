#!/bin/bash

# Second part of the driver:
## After spat:
sbatch ./mpmds/mpmd_eke.sh # EKE
./mon_drift.sh # drift style compilation
