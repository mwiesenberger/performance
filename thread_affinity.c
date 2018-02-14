/*
The MIT License (MIT)

Copyright (c) 2018 Siegfried Höfinger, Matthias Wiesenberger

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <omp.h>
#include <sched.h>

int sched_getcpu(void); //forward declare glibc function to avoid compiler warnings

//******************************************************//
//compile with gcc:                                     //
//mpicc thread_affinity.c -o thread_affinity -fopenmp   //
//compile with icc:                                     //
//mpiicc thread_affinity.c -o thread_affinity -qopenmp  //
//******************************************************//
int main(int argc, char **argv)
{
    int i,j,k,l, task, ntasks, thread, nthreads, cpuid;
    char node_name[MPI_MAX_PROCESSOR_NAME];

    // determine MPI task and total number of MPI tasks
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &task);
    MPI_Comm_size(MPI_COMM_WORLD, &ntasks);

    // determine total number of OpenMP threads, thread number,
    // associated core and hostname and print in correct order
    nthreads = omp_get_max_threads();
    for( i=0; i<ntasks; i++)
    {
        if(task==i)
        {
            MPI_Get_processor_name(&node_name[0], &l);
            #pragma omp parallel for schedule(static,1) ordered private(thread, cpuid)
            for ( j=0; j<nthreads; j++) {
                thread = omp_get_thread_num();
                cpuid = sched_getcpu();
                printf("node %s, task %d of  %d tasks, thread %d of %d threads, on cpu  %d \n",
                        &node_name[0], task, ntasks, thread, nthreads, cpuid);
            }
        }
        MPI_Barrier(MPI_COMM_WORLD);
    }

    MPI_Finalize();

   return 0;
}
