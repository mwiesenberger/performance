#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 1 -n XXX --qos= XXX -p XXX
#SBATCH --time=10:00:00

###please specify a info file (for humans)
#SBATCH -o "benchmark_v100nv_mpi.info"
FILENAME='benchmark_v100nv_mpi' # name of output file
NAME='Nvidia Tesla V100 with NVLink (DAVIDE)'
REPETITIONS=10


echo "$NAME"
echo "$REPETITIONS"
hostname
date
module list
git rev-parse --verify HEAD
make cluster_mpib device=gpu
mpirun -n 1 ./ping_mpit
#mpirun -n 2 ./ping_mpit
#mpirun -n 4 ./ping_mpit
#mpirun -n 8 ./ping_mpit

COMMAND='mpirun -n 1 ./cluster_mpib'
FILE=""$FILENAME"1.csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 3 4; do
        for N in 32 64 128 256; do
            for Nz in 16 32 64 128; do
                echo "1 1 1 $o $N $N $Nz" | $COMMAND >> $FILE
            done
        done
    done
done

#COMMAND='mpirun -n 2 ./cluster_mpib'
#FILE=""$FILENAME"2.csv"
#echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
#for ((n=0;n<$REPETITIONS;n++)); do
#    for o in 3 4; do
#        for N in 32 64 128 256; do
#            for Nz in 16 32 64 128; do
#               echo "1 1 2 $o $N $N $Nz" | $COMMAND >> $FILE
#            done
#        done
#    done
#done
#
#COMMAND='mpirun -n 4 ./cluster_mpib'
#FILE=""$FILENAME"4.csv"
#echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
#for ((n=0;n<$REPETITIONS;n++)); do
#    for o in 3 4; do
#        for N in 32 64 128 256; do
#            for Nz in 16 32 64 128; do
#               echo "1 1 4 $o $N $N $Nz" | $COMMAND >> $FILE
#            done
#        done
#    done
#done
#
#COMMAND='mpirun -n 8 ./cluster_mpib'
#FILE=""$FILENAME"8.csv"
#echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
#for ((n=0;n<$REPETITIONS;n++)); do
#    for o in 3 4; do
#        for N in 32 64 128 256; do
#            for Nz in 16 32 64 128; do
#               echo "1 1 8 $o $N $N $Nz" | $COMMAND >> $FILE
#            done
#        done
#    done
#done
date
