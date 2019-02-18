//Time command implementation for Project 2.
#ifdef CS333_P2
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int pid = fork();
  int start = uptime();
  
  if (pid < 0) //error
  {
    printf(2, "Error. Process did not run.\n");
    exit();
  }

  if(pid == 0) //in the child. Successfully created the new process
  {
    exec(argv[1], &argv[1]);
    exit();
  }

  wait(); //in the parent

  int end = uptime();
  int total = end - start;
  int sec = total/1000;
  int milisec = total%1000;

  if(total % 100 < 10)
    printf(1, "%s ran in %d.0%d seconds.\n", argv[1], sec, milisec); 

  else
    printf(1, "%s argument ran in %d.%d seconds.\n", argv[1], sec, milisec);
  
  exit();
  return 1;
}
#endif
