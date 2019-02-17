#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"
#define MAX 72; //altered for testing

int
main(void)
{ 
  uint max = MAX;
  struct uproc *table = malloc(max * sizeof(struct uproc));
  int num = getprocs(max, table);  

  printf(1, "\nMAX = %d\n", max); //Display the current MAX value for 1, 16, 64, and 72 

  printf(1, "\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n"); //Print the header

  for (int i = 0; i < num; ++i)
  {
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid);

    int sec = table[i].elapsed_ticks/1000; //Find sec
    int ms = table[i].elapsed_ticks%1000; //Find milisec for elapsed
    printf(1, "%d.", sec); 

    if(ms < 10)
      printf(1, "00%d\t", ms);

    else if(ms < 100)
      printf(1, "0%d\t", ms);

    else
      printf(1, "%d\t", ms);

    sec = table[i].CPU_total_ticks/1000; //Find Sec
    ms = table[i].CPU_total_ticks%1000; //Find milisec for CPU

    printf(1, "%d.", sec); 

    if(ms <10)
       printf(1, "00%d\t", ms);

    else if(ms < 100)
       printf(1, "0%d\t", ms);

    else
       printf(1, "%d\t", ms);

    printf(1, "%s\t%d\n", table[i].state, table[i].size); // Display state and size
  }
  exit();
}

#endif


