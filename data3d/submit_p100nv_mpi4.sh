#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 1 -n 4 -A fusio_ru3DTU_1 --gres=gpu:4 -p dvd_fua_prod
#SBATCH --time=12:00:00

###please specify a info file (for humans)
#SBATCH -o "benchmark_p100nv_mpi4.info"
FILENAME='benchmark_p100nv_mpi4' # name of output file
NAME='Nvidia Tesla P100 with NvLink (DAVIDE)'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname 
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=gpu
mpirun -n 4 ./ping_mpit

COMMAND='mpirun -n 4 ./cluster_mpib'
FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 3 4; do
        for N in 34 68 136 272; do
            for Nz in 16 32 64 128; do
                echo "1 1 4 $o $N $N $Nz" | $COMMAND ./cluster_mpib >> $FILE
            done
        done
    done
done
date
