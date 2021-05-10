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

for celldm in  45 40 35 30 25 20 15; 
do

cat>ag13-scf-$celldm-pw.in<<EOF

&CONTROL
  calculation = 'scf' ,
  outdir = './tmp/',
  pseudo_dir = '../../pseudo' ,
  prefix = 'ag13' ,
  verbosity = 'high' ,
 /
 &SYSTEM
    ibrav = 1 ,
    celldm(1) = $celldm ,
    nat = 13 ,
    ntyp = 1 ,
    ecutwfc = 32 ,
    ecutrho = 165,
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
Ag            4.4752016222        4.3766710014        8.5127887133
Ag            5.3785389583        9.3597198394       10.7303586265
Ag           12.9870255737        6.6146392095        6.9095922668
Ag            9.3309881134        5.4977821312       10.9048616913
Ag           10.3889070352        6.1793709547        2.0478448393
Ag           11.2921728838       11.1635484948        4.2643839820
Ag            5.1300699537        4.7965856240        3.0384066110
Ag            7.8837726104        7.7700415274        6.3883648306
Ag            6.5877195949       12.8607369211        6.6248553689
Ag           10.6372230075       10.7439989750        9.7370985761
Ag            2.7808384974        8.9242109344        5.8673960530
Ag            6.4360178481       10.0426308787        1.8720827266
Ag            9.1772842973        2.6790235543        6.1522057595
 K_POINTS {gamma}

EOF
mpirun -n 24 pw.x < ag13-scf-$celldm-pw.in > ag13-scf-$celldm-pw.out
done
