#!/bin/bash

FILENAME='benchmark_titanxp' # name of output file
NAME='NVIDIA GTX Titan Xp'
REPETITIONS=10

echo "$NAME"
echo "$REPETITIONS"
hostname 
date
git rev-parse --verify HEAD
make cluster_mpib device=gpu

COMMAND='mpirun -n 1'
$COMMAND ./ping_mpit

FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 3 4; do
        for N in 32 64 128 256; do
            for Nz in 16 32 64 128; do
                echo "1 1 1 $o $N $Nz 1" | $COMMAND ./cluster_mpib >> $FILE
        done
    done
done
date
