#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 4 -n 16 --ntasks-per-node=4 -A fuac4_feltor --exclusive --gres=gpu:4 -p m100_fua_prod
#SBATCH --time=12:00:00

###please specify a info file (for humans)
#SBATCH -o "benchmark_v100nv_mpi16.info"
FILENAME='benchmark_v100nv_mpi16' # name of output file
NAME='Nvidia Tesla V100 with NvLink (M100)'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname 
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=gpu
mpirun -gpu -n 16 ./ping_mpit

COMMAND='mpirun -gpu -n 16 ./cluster_mpib'
FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 3 4; do
        for N in 34 68 136 272; do
            for Nz in 32 64 128; do
                echo "1 1 16 $o $N $N $Nz" | $COMMAND ./cluster_mpib >> $FILE
            done
        done
    done
done
date
