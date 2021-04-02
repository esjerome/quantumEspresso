#!/bin/bash

#SBATCH --job-name=plata
#SBATCH --partition=guane_24_cores
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --output=qe.out
#SBATCH --error=qe.erra

module load pmix/2.2.2
module load QuantumExpresso/6.5
export FI_PROVIDER=tcp

cat>plata-nscf-pw.in<<EOF

&CONTROL
  calculation = 'nscf' ,
  outdir = './tmp/',
  pseudo_dir = '../../pseudo' ,
  prefix = 'plata' ,
  verbosity = 'high' ,
 /
 &SYSTEM
    ibrav = 1 ,
    celldm(1) = 45 ,
    nat = 1,
    ntyp = 1 ,
    ecutwfc = 32 ,
    ecutrho = 192 ,
    occupations = 'smearing' ,
    smearing = 'fd' ,
    degauss = 0.002,
    starting_magnetization(1) = 0.5,
    nspin = 2 ,
 /
 &ELECTRONS
     mixing_beta = 0.7 ,
     mixing_mode = 'local-TF' ,
     conv_thr = 1.0d-8 ,
 /
ATOMIC_SPECIES
   Ag   107.87  Ag.pbe-dn-kjpaw_psl.0.1.UPF
ATOMIC_POSITIONS (bohr)
Ag            4.4752016222        4.3766710014        8.5127887133
 K_POINTS {gamma}

EOF
mpirun -n 24 pw.x < plata-nscf-pw.in > plata-nscf-pw.out
