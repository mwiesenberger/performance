#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 4 -n 8 --ntasks-per-socket=1 -c 24 --hint=memory_bound
#SBATCH --partition=skl_fua_prod 
#SBATCH --account=FUA32_FELTOR
#SBATCH --mem=182000
#SBATCH --time=12:00:00


###please specify a info file (for humans)
#SBATCH -o "benchmark_skl_mpi4.info"
FILENAME='benchmark_skl_mpi4' # name of output file
NAME='Marconi Skylake'
PROGRAM='cluster_skl'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname 
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=skl
#mv cluster_mpib $PROGRAM

srun --mpi=pmi2 ./test_mpit

COMMAND='srun --mpi=pmi2'
FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 128 256 384 512 768 1024 1536 2048; do
                echo "2 4 1 $o $N $N 1" | $COMMAND ./$PROGRAM >> $FILE
        done
    done
done
date
