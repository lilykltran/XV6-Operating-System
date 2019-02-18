#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"  
#include "uproc.h"
#ifdef PDX_XV6
#include "pdx-kernel.h"
#endif // PDX_XV6

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  xticks = ticks;
  return xticks;
}

#ifdef PDX_XV6
// Turn off the computer
int
sys_halt(void)
{
  cprintf("Shutting down ...\n");
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}
#endif // PDX_XV6



#ifdef CS333_P1
//Checks if argument successfully was read. Get the time.
int
sys_date(void)
{
  struct rtcdate *d;
  
  if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
    return -1;

  cmostime(d);
  return 0;
}
#endif


#ifdef CS333_P2
//Returns the uid
uint
sys_getuid(void)
{
  return myproc() -> uid;
}


//Returns the gid
uint
sys_getgid(void)
{
  return myproc() -> gid;
}


//Returns the ppid
uint
sys_getppid(void)
{
  if(myproc() -> parent == NULL)
     return myproc() -> pid;
 
  return myproc() -> parent -> pid;
}


//Called by test1P2. Makes sure uid is set in the correct range.
int
sys_setuid(void)
{
  int uid;
   
  if(argint(0, &uid) < 0)
    return -1;
  cprintf("UID TEST: my variable is %d\n", uid);
  if(uid < 0 || uid > 32767)
    return -1;

  setuid(uid);
  return 1;
}


//Called by test1P2. Makes sure gid is set in the correct range.
int
sys_setgid(void)
{
  int gid;
   
  if(argint(0, &gid) < 0)
    return -1;
  cprintf("GID TEST: my variable is %d\n", gid);
  if(gid < 0 || gid > 32767)
    return -1;

  setgid(gid);
  return 1;
}


//Wrapper for getting the current processes. 
int
sys_getprocs(void)
{
  int max;
  struct uproc * table;
  if (argint(0, &max) < 0 || argptr(1, (void*)&table, sizeof(struct uproc)) < 0)
    return -1;

  else
  {
    if(max > 0)
      return getprocs(max, table); //implemented in proc.c
    else
      return -1;
  }
}
#endif
