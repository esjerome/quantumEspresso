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

for factor in 5 ;

do

let "ecutrho = $factor*80";

cat>ag12bil-scf-$factor-pw.in<<EOF

&CONTROL
  calculation = 'scf' ,
  outdir = './tmp/',
  pseudo_dir = '../../pseudo' ,
  prefix = 'ag12Bil' ,
  verbosity = 'high' ,
 /
 &SYSTEM
    ibrav = 1 ,
    celldm(1) = 30 ,
    nat = 13 ,
    ntyp = 2 ,
    ecutwfc = 80 ,
    ecutrho = $ecutrho ,
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
Ag            4.4464913393        4.3484877493        8.561114
Ag            5.3824813288        9.3397712053       10.6909562317
Ag           12.9459865862        6.6095578214        6.8932663014
Ag            9.3132021816        5.5011771168       10.8651506839
Ag           10.4383280817        6.1763041519        2.0093808458
Ag           11.2612241324       11.1323762376        4.2643642766
Ag            5.1404952336        4.8092764563        3.0525096607
Ag            7.7944678853        7.6739312536        6.2805557323
Ag            6.5864529136       12.8195222157        6.6110616031
Bi           10.8050073082       10.9230514326        9.9408893708
Ag            2.7280868878        8.9579319000        5.8803915936
Ag            6.4326182564       10.0894244957        1.8322444064
Ag            9.2109178612        2.6281480099        6.1683590145
 K_POINTS {gamma}

EOF
mpirun -n 24 pw.x < ag12bil-scf-$factor-pw.in > ag12bil-scf-$factor-pw.out
done