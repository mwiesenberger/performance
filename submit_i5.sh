#!/bin/bash

FILENAME='benchmark_i5' # name of output file
NAME='Intel i5-6600'
PROGRAM='cluster_mpib'
REPETITIONS=1

echo "$NAME"
echo "$REPETITIONS"
hostname 
date
git rev-parse --verify HEAD
make cluster_mpib device=omp

export OMP_NUM_THREADS=4
export GOMP_CPU_AFFINITY="0-3"
COMMAND='mpirun -n 1'
$COMMAND ./ping_mpit

FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 128 256 384 512 768 1024 1536 2048; do
                echo "1 1 1 $o $N $N 1" | $COMMAND ./$PROGRAM >> $FILE
        done
    done
done
date
