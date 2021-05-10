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

cat>ag12Bic.dos.in<<EOF
&DOS
    outdir = './tmp' ,
    prefix = 'ag12Bic' ,
    fildos = 'ag12Bic.dos' ,
    DeltaE = 0.001,
 /  
EOF
mpirun -n 24 dos.x < ag12Bic.dos.in > ag12Bic.dos.out
