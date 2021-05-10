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

cat>ag12bic-nscf-pw.in<<EOF

&CONTROL
  calculation = 'nscf' ,
  outdir = './tmp/',
  pseudo_dir = '../../pseudo' ,
  prefix = 'ag12Bic' ,
  verbosity = 'high' ,
 /
 &SYSTEM
    ibrav = 1 ,
    celldm(1) = 45 ,
    nat = 13 ,
    ntyp = 2 ,
    ecutwfc = 80 ,
    ecutrho = 375 ,
    occupations = 'smearing' ,
    smearing = 'fd' ,
    degauss = 0.002,
    starting_magnetization(1) = 0.5,
    starting_magnetization(2) = 0.5,
    nspin = 2 ,
 /
 &ELECTRONS
     mixing_beta = 0.7 ,
     mixing_mode = 'local-TF',
     conv_thr = 1.0d-8,
 /
ATOMIC_SPECIES
   Ag   107.87  Ag.pbe-dn-kjpaw_psl.0.1.UPF
   Bi   208.98  Bi.pbe-dn-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS (bohr)
Ag            12.3552665330        12.2570342464        16.5876865699
Ag            13.2908457923        17.4159295940       18.8818674624
Ag           21.1659627571        14.5738198285        14.9269386071
Ag            17.3813968924        13.4182762182       19.0628882701
Ag           18.4769251227        14.1241965083        9.8947836038
Ag           19.4127095808       19.2829102030        12.1906264917
Ag            13.0318543411        12.6920189641        10.9211953202
Bi            15.8835644055        15.7699573051        14.3879320795
Ag            14.5429715685       21.0393156740        14.6337819792
Ag           18.7348044387       18.8481758821        17.8554133134
Ag            10.6009475839        16.9655286252        13.8492144949
Ag            14.3853515479       18.1216832128        9.7137172849
Ag            17.2231594323        10.5001137844        14.1441945678
 K_POINTS {gamma}

EOF
mpirun -n 24 pw.x < ag12bic-nscf-pw.in > ag12bic-nscf-pw.out
