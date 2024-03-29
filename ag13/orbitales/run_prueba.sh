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

cat>ag13-scf-pw.in<<EOF

&CONTROL
  calculation = 'scf' ,
  outdir = './tmp/',
  pseudo_dir = '../../pseudo' ,
  prefix = 'ag13' ,
  verbosity = 'high' ,
 /
 &SYSTEM
    ibrav = 1 ,
    celldm(1) = 30 ,
    nat = 13 ,
    ntyp = 1 ,
    ecutwfc = 32 ,
    ecutrho = 192 ,
    occupations = 'smearing' ,
    smearing = 'fd' ,
    degauss = 0.0007,
    starting_magnetization(1) = 0.7,
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
Ag            12.4752016222        12.3766710014        16.5127887133
Ag            13.3785389583        17.3597198394       18.7303586265
Ag           20.9870255737        14.6146392095        14.9095922668
Ag            17.3309881134        13.4977821312       18.9048616913
Ag           18.3889070352        14.1793709547        10.0478448393
Ag           19.2921728838       19.1635484948        12.2643839820
Ag            13.1300699537        12.7965856240        11.0384066110
Ag            15.8837726104        15.7700415274        14.3883648306
Ag            14.5877195949       20.8607369211        14.6248553689
Ag           18.6372230075       18.7439989750        17.7370985761
Ag            10.7808384974        16.9242109344        13.8673960530
Ag            14.4360178481       18.0426308787        9.8720827266
Ag            17.1772842973        10.6790235543        14.1522057595
 K_POINTS {gamma}

EOF
mpirun -n 24 pw.x < ag13-scf-pw.in > ag13-scf-pw.out
