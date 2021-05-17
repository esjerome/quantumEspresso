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

cat>ag12bil-scf-pw.in<<EOF

&CONTROL
  calculation = 'scf' ,
  outdir = './tmp/',
  pseudo_dir = '../../pseudo' ,
  prefix = 'ag12Bic' ,
  verbosity = 'high' ,
 /
 &SYSTEM
    ibrav = 1 ,
    celldm(1) = 30 ,
    nat = 13 ,
    ntyp = 2 ,
    ecutwfc = 75 ,
    ecutrho = 300,
    occupations = 'smearing' ,
    smearing = 'fd' ,
    degauss = 0.0007,
    starting_magnetization(1) = 0.7,
    starting_magnetization(2) = 0.7,
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
Ag            12.4464913393        12.3484877493        16.5611103244
Ag            13.3824813288        17.3397712053       18.6909562317
Ag           20.9459865862        14.6095578214        14.8932663014
Ag            17.3132021816        13.5011771168       18.8651506839
Ag           18.4383280817        14.1763041519        10.0093808458
Ag           19.2612241324       19.1323762376        12.2643642766
Ag            13.1404952336        12.8092764563        11.0525096607
Ag            15.7944678853        15.6739312536        14.2805557323
Ag            14.5864529136       20.8195222157        14.6110616031
Bi           18.8050073082       18.9230514326        17.9408893708
Ag            10.7280868878        16.9579319000        13.8803915936
Ag            14.4326182564       18.0894244957        9.8322444064
Ag            17.2109178612        10.6281480099        14.1683590145
 K_POINTS {gamma}

EOF
mpirun -n 24 pw.x < ag12bil-scf-pw.in > ag12bil-scf-pw.out
done