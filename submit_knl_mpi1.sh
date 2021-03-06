#!/bin/bash

#SBATCH -J benchmark
#SBATCH -N 1 -n 1 --cpus-per-task=272
#SBATCH --partition=knl_fua_prod 
#SBATCH --constraint=cache
#SBATCH --account=FUA22_FELTOR
#SBATCH --time=12:00:00


###please specify a info file (for humans)
#SBATCH -o "benchmark_knl_mpi1.info"
FILENAME='benchmark_knl_mpi1' # name of output file
NAME='Marconi KNL'
REPETITIONS=10

export OMP_NUM_THREADS=136

echo "$NAME"
echo "$REPETITIONS"
hostname 
module list
git rev-parse --verify HEAD
make cluster_mpib device=knl

srun --mpi=pmi2 ./ping_mpit

COMMAND='srun --mpi=pmi2'
FILE=""$FILENAME".csv"
echo '"npx" "npy" "npz" "procs" "threads" "n" "Nx" "Ny" "Nz" "scal" "axpby" "pointwiseDot" "dot" "dx" "dy" "dz" "arakawa" "iterations" "cg" "ds" "exblas_d" "exblas_i"' > $FILE
for ((n=0;n<$REPETITIONS;n++)); do
    for o in 2 3 4 5; do
        for N in 136 272 408 544 816 1088 1632 2176; do
            echo "1 1 1 $o $N $N 1" | $COMMAND ./cluster_mpib >> $FILE
        done
    done
done
