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

cat>ag12bic-scf-$celldm-pw.in<<EOF

&CONTROL
  calculation = 'scf' ,
  outdir = './tmp/',
  pseudo_dir = '../../pseudo' ,
  prefix = 'ag12Bic' ,
  verbosity = 'high' ,
 /
 &SYSTEM
    ibrav = 1 ,
    celldm(1) = $celldm ,
    nat = 13 ,
    ntyp = 2 ,
    ecutwfc = 45 ,
    ecutrho = 455,
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
   Bi   208.98  Bi.pbe-dn-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS (bohr)
Ag            4.3552665330        4.2570342464        8.5876865699
Ag            5.2908457923        9.4159295940       10.8818674624
Ag           13.1659627571        6.5738198285        6.9269386071
Ag            9.3813968924        5.4182762182       11.0628882701
Ag           10.4769251227        6.1241965083        1.8947836038
Ag           11.4127095808       11.2829102030        4.1906264917
Ag            5.0318543411        4.6920189641        2.9211953202
Bi            7.8835644055        7.7699573051        6.3879320795
Ag            6.5429715685       13.0393156740        6.6337819792
Ag           10.7348044387       10.8481758821        9.8554133134
Ag            2.6009475839        8.9655286252        5.8492144949
Ag            6.3853515479       10.1216832128        1.7137172849
Ag            9.2231594323        2.5001137844        6.1441945678
 K_POINTS {gamma}

EOF
mpirun -n 24 pw.x < ag12bic-scf-$celldm-pw.in > ag12bic-scf-$celldm-pw.out
done