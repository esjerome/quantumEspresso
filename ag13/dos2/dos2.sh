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

cat>ag13.dos.in<<EOF
&DOS
    outdir = './tmp' ,
    prefix = 'ag13' ,
    fildos = 'ag13.dos' ,
    DeltaE = 0.001,
 /  
EOF
mpirun -n 24 dos.x < ag13.dos.in > ag13.dos.out
