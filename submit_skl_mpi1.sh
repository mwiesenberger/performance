#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 1 -n 2 --ntasks-per-socket=1 -c 24 --hint=memory_bound
#SBATCH --partition=skl_fua_prod 
#SBATCH --account=FUA32_FELTOR
#SBATCH --mem=182000
#SBATCH --time=12:00:00


###please specify a info file (for humans)
#SBATCH -o "benchmark_skl_mpi1.info"
FILENAME='benchmark_skl_mpi1' # name of output file
NAME='Marconi Skylake'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname 
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=skl

srun --mpi=pmi2 ./ping_mpit

COMMAND='srun --mpi=pmi2'
FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 144 288 384 576 768 1152 1536 1920; do
            echo "1 2 1 $o $N $N 1" | $COMMAND ./cluster_mpib >> $FILE
        done
    done
done
date
