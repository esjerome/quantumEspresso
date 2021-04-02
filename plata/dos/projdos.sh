#!/bin/bash

#SBATCH --job-name=plata_proj_dos
#SBATCH --partition=guane_24_cores
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --output=qe.out
#SBATCH --error=qe.erra

module load pmix/2.2.2
module load QuantumExpresso/6.5
export FI_PROVIDER=tcp

cat>plata.projdos.in<<EOF
&PROJWFC
    outdir = './tmp',
    prefix = 'plata',
    filpdos = 'plata.dos',
    filproj = 'plata.pdos',
    DeltaE = 0.001
 /
EOF
mpirun -n 24 projwfc.x < plata.projdos.in > plata.projdos.out
