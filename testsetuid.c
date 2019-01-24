#ifdef CS333_P2
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int toSet = 15;
  setuid(toSet);
  printf(1, "***** Expecting: %d,  actual:  %d\n\n", toSet, getuid());

  toSet = 99;
  setgid(toSet);
  printf(1, "***** Expecting: %d,  actual:  %d\n\n", toSet, getgid());

  printf(1, "PPID: %d\n\n", getppid());
  exit();

}
#endif
