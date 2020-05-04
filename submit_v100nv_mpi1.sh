#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 1 -n 1 -A fuac4_feltor --gres=gpu:1 -p m100_fua_prod
#SBATCH --time=8:00:00

###please specify a info file (for humans)
#SBATCH -o "benchmark_v100nv_mpi1.info"
FILENAME='benchmark_v100nv_mpi1' # name of output file
NAME='Nvidia Tesla V100 with NvLink (M100)'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname 
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=gpu
mpirun -gpu -n 1 ./ping_mpit

COMMAND='mpirun -gpu -n 1 ./cluster_mpib'
FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 128 256 384 512 768 1024 1536 2048; do
            echo "1 1 1 $o $N $N 1" | $COMMAND >> $FILE
        done
    done
done
date
