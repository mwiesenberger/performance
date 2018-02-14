#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 1 -n 1 --qos=normal -p hsw_v100
#SBATCH --time=10:00:00

###please specify a info file (for humans)
#SBATCH -o "benchmark_v100_mpi.info"
FILENAME='benchmark_v100_mpi' # name of output file
NAME='Nvidia Tesla V100 (PSG)'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname 
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=gpu

COMMAND='mpirun -n 1 ./cluster_mpib'
FILE=""$FILENAME"1.csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 128 256 384 512 768 1024 1536 2048; do
            echo "1 1 1 $o $N $N 1" | $COMMAND >> $FILE
        done
    done
done
date

#COMMAND='mpirun -n 2 ./cluster_mpib'
#FILE=""$FILENAME"2.csv"
#echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
#for o in 2 3 4 6; do
#    for N in 256 512 1024 2048; do
#        for ((n=0;n<$REPETITIONS;n++)); do
#            echo "1 2 1 $o $N $N 1" | $COMMAND >> $FILE
#        done
#    done
#done
#
#COMMAND='mpirun -n 4 ./cluster_mpib'
#FILE=""$FILENAME"4.csv"
#echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
#for o in 2 3 4 6; do
#    for N in 256 512 1024 2048; do
#        for ((n=0;n<$REPETITIONS;n++)); do
#            echo "2 2 1 $o $N $N 1" | $COMMAND >> $FILE
#        done
#    done
#done
