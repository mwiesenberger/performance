#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 2 -n 4 --ntasks-per-socket=1 -c 8
#SBATCH --time=12:00:00


###please specify a info file (for humans)
#SBATCH -o "benchmark_vsc_mpi2.info"
FILENAME='benchmark_vsc_mpi2' # name of output file
NAME='VSC3 cpus'
PROGRAM='cluster_mpib'
REPETITIONS=10
COMMAND='srun --mpi=pmi2'


echo "$NAME"
echo "$REPETITIONS"
hostname
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=omp
make ping_mpit device=omp

$COMMAND ./ping_mpit

FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 128 256 384 512 768 1024 1536 2048; do
                echo "2 2 1 $o $N $N 1" | $COMMAND ./$PROGRAM >> $FILE
        done
    done
done
date
