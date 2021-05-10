#!/bin/bash

#SBATCH --job-name=QE
#SBATCH --partition=guane_24_cores
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --output=qe.out
#SBATCH --error=qe.erra

module load pmix/2.2.2
module load QuantumExpresso/6.5
export FI_PROVIDER=tcp

cat>ag12Bil.pdos.in<<EOF
&PROJWFC
    outdir = './tmp' ,
    prefix = 'ag12Bil' ,
    filpdos = 'ag12Bil.dos' ,
    filproj = 'ag12Bil.pdos',
    Emin = -40,
    DeltaE = 0.001,
 /
EOF
mpirun -n 24 projwfc.x < ag12Bil.pdos.in > ag12Bil.pdos.out
