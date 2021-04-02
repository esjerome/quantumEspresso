#!/bin/bash

#SBATCH --job-name=plata_dos
#SBATCH --partition=guane_24_cores
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --output=qe.out
#SBATCH --error=qe.erra
          
module load pmix/2.2.2
module load QuantumExpresso/6.5
export FI_PROVIDER=tcp

cat>plata.dos.in<<EOF
&DOS
    outdir = './tmp' ,
    prefix = 'plata' ,
    fildos = 'plata.dos' ,
    Emin = -10,
    DeltaE = 0.001,
 /  
EOF
mpirun -n 24 dos.x < plata.dos.in > plata.dos.out
