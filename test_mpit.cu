#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <omp.h>
#include <sched.h>

int main(int, char **);


int main(int argc, char **argv)
{
   int i, l, dmmy, task, ntasks, thread, nthreads, cpuid;
   char node_name[MPI_MAX_PROCESSOR_NAME];



   // determine MPI task and total number of MPI tasks 
   MPI_Init(&argc, &argv);
   MPI_Comm_rank(MPI_COMM_WORLD, &task);
   MPI_Comm_size(MPI_COMM_WORLD, &ntasks);


   // determine total number of OpenMP threads, thread number, 
   // associated core and hostname
   nthreads = omp_get_max_threads();
   for( int i=0; i<ntasks; i++)
   {
       if(task==i)
       {
   #pragma omp parallel for private(thread, cpuid)
   for (i=0; i<nthreads; i++) {
      thread = omp_get_thread_num(); 
      cpuid = sched_getcpu();
      dmmy = MPI_Get_processor_name(&node_name[0], &l);
      printf("node %s, task %d of  %d tasks, thread %d of %d threads, on cpu  %d \n", 
             &node_name[0], task, ntasks, thread, nthreads, cpuid);
   }
       }
       MPI_Barrier(MPI_COMM_WORLD);
   }

   
   return 0;
}
