#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 1 -n 2 -A fusio_ru3DTU_1 --gres=gpu:2 -p dvd_fua_prod
#SBATCH --time=12:00:00

###please specify a info file (for humans)
#SBATCH -o "benchmark_p100nv_mpi2.info"
FILENAME='benchmark_p100nv_mpi2' # name of output file
NAME='Nvidia Tesla P100 with NvLink (DAVIDE)'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname 
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=gpu
mpirun -n 2 ./ping_mpit

COMMAND='mpirun -n 2 ./cluster_mpib'
FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 128 256 384 512 768 1024 1536 2048; do
            echo "1 2 1 $o $N $N 1" | $COMMAND >> $FILE
        done
    done
done
date
