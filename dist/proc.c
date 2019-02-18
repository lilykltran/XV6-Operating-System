#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "uproc.h"
#define unused 0
#define embryo 1
#define sleeping 2
#define runnable 3
#define running 4
#define zombie 5
#define statecount NELEM(states)
// Testing git

static char *states[] = {
[UNUSED]    "unused",
[EMBRYO]    "embryo",
[SLEEPING]  "sleep ",
[RUNNABLE]  "runble",
[RUNNING]   "run   ",
[ZOMBIE]    "zombie"
};
#ifdef CS333_P3
  struct ptrs {
    struct proc * head;
    struct proc * tail;
};
#endif
static struct {
  struct spinlock lock;
  struct proc proc[NPROC];
#ifdef CS333_P3
  struct ptrs list[statecount];
#endif
} ptable;


static struct proc *initproc;

uint nextpid = 1;
extern void forkret(void);
extern void trapret(void);
static void wakeup1(void* chan);
#ifdef CS333_P3
static void initProcessLists(void);
static void initFreeList(void);
static void stateListAdd(struct ptrs*list, struct proc* p);
static int stateListRemove(struct ptrs*list, struct proc* p);
//static void stateListAddAtHead(struct ptrs*list, struct proc* p);
static void assertState(struct proc* p, enum procstate state);
#endif

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;

  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid) {
      return &cpus[i];
    }
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

#ifdef CS333_P3
// Adds processes to the tail of the list
void
stateListAdd(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL){
    (*list).head = p;
    (*list).tail = p;
    p->next = NULL;
  } else{
    ((*list).tail)->next = p;
    (*list).tail = ((*list).tail)->next;
    ((*list).tail)->next = NULL;
  }
}

/*
// Add processes at the head of the list
static void
stateListAddAtHead(struct ptrs*list, struct proc* p)
{
  p -> next = (*list).head;
  (*list).head = p;
}
*/

// Makes sure state of process we are working with is the correct state it should be
void 
assertState(struct proc*p, enum procstate state) 
{
  if(p -> state != state)
  {
    cprintf("We're in %s, we want to be in %s\n", states[p->state], states[state]);
    panic ("No Match");  
  }

  else
    return;
}

// Removing process p from specific list
int
stateListRemove(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL || (*list).tail == NULL || p == NULL){
    return -1;
  }

  struct proc* current = (*list).head;
  struct proc* previous = 0;

  if(current == p){
    (*list).head = ((*list).head)->next;
    // prevent tail remaining assigned when we've removed the only item
    // on the list
    if((*list).tail == p){
      (*list).tail = NULL;
    }
    return 0;
  }

  while(current){
    if(current == p){
      break;
    }

    previous = current;
    current = current->next;
  }

  // Process not found. return error
  if(current == NULL){
    return -1;
  }

  // Process found.
  if(current == (*list).tail){
    (*list).tail = previous;
    ((*list).tail)->next = NULL;
  } else{
    previous->next = current->next;
  }

  // Make sure p->next doesn't point into the list.
  p->next = NULL;

  return 0;
}

// Initialize each process to null in list array
void
initProcessLists()
{
  int i;

  for (i = UNUSED; i <= ZOMBIE; i++) {
    ptable.list[i].head = NULL;
    ptable.list[i].tail = NULL;
  }
#ifdef CS333_P4
  for (i = 0; i <= MAXPRIO; i++) {
    ptable.ready[i].head = NULL;
    ptable.ready[i].tail = NULL;
  }
#endif
}

// Initialize all processes in original list to the unused state and add each state to the new list
void
initFreeList(void)
{
  struct proc* p;

  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
    p->state = UNUSED;
    stateListAdd(&ptable.list[UNUSED], p);
  }
}
#endif

// New implementation of allocproc to work with the new list
#ifdef CS333_P3
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  int found = 0;
  
  p = ptable.list[UNUSED].head;

  if(p)
  {
    found = 1;
  }

  if (!found) {
    release(&ptable.lock);
    return 0;
  }

  int rc = stateListRemove(&ptable.list[UNUSED], p);
  if (rc == -1)
    panic("ERROR. Allocproc removal failed\n");
  assertState(p, UNUSED);
  p->state = EMBRYO;
  stateListAdd(&ptable.list[EMBRYO], p);
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0)
  {
    acquire(&ptable.lock);
    stateListRemove(&ptable.list[EMBRYO], p);
    assertState(p, EMBRYO);
    p->state = UNUSED;
    stateListAdd(&ptable.list[UNUSED], p);
    release(&ptable.lock);
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  #ifdef CS333_P1
  p -> start_ticks = ticks;
  #endif

  #ifdef CS333_p2
  p -> cpu_ticks_in = 0;
  p -> cpu_ticks_total = 0;
  #endif

  return p; 
}

#else
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  int found = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED) {
      found = 1;
      break;
    }
  if (!found) {
    release(&ptable.lock);
    return 0;
  }
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  #ifdef CS333_P1
  p -> start_ticks = ticks;
  #endif

  #ifdef CS333_p2
  p -> cpu_ticks_in = 0;
  p -> cpu_ticks_total = 0;
  #endif

  return p;
}
#endif

// New implementation of userinit
#ifdef CS333_P3
void
userinit(void)
{
  struct proc *p;
  acquire(&ptable.lock);
  initProcessLists();
  initFreeList();
  release(&ptable.lock);
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  stateListRemove(&ptable.list[p->state], p);
  assertState(p, EMBRYO);
  p->state = RUNNABLE;
  stateListAdd(&ptable.list[p->state], p);
  release(&ptable.lock);

#ifdef CS333_P2
  p->uid = UID; //setting to default
  p->gid = GID; //setting to default
#endif
}

// Set up first user process
#else
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  p->state = RUNNABLE;
  release(&ptable.lock);

#ifdef CS333_P2
  p->uid = UID; //setting to default
  p->gid = GID; //setting to default
#endif
}
#endif
   
#ifdef CS333_P3
// Traverses and prints for console commands
int
traverse(int state)
{
  int ucount = 0;

  if(state == 3) //runnable processes
    cprintf("\nReady List Processes:\n");

  if(state == 2) //sleeping processes
    cprintf("\nSleep List Processes:\n");

  if(state == 5) //zombie processes
    cprintf("\nZombie List Processes:\n");

  struct proc * current = ptable.list[state].head;

  while(current)
  {
    if(state == 2 || state == 3) //runnable or sleeping
    {
      cprintf("%d -> ", current -> pid);  
      current = current -> next;
    }

    else if(state == 0) //unused 
    {
      current = current -> next;
      ++ucount; //count number of unused processes
    }
 
    else if(state == 5) //zombie 
    {
      cprintf("(%d, %d) -> ", current -> pid, current -> parent);
      current = current -> next;
    }
  }

  if(state == 0)
    cprintf("Free List Size: %d\n", ucount);

  return 0;
}
#endif

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}


#ifdef CS333_P3
// New implementation of fork
int
fork(void)
{
  int i;
  uint pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    acquire(&ptable.lock);
    stateListRemove(&ptable.list[EMBRYO], np);
    assertState(np, EMBRYO);
    np->state = UNUSED;
    stateListAdd(&ptable.list[UNUSED], np);
    release(&ptable.lock);
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);
  stateListRemove(&ptable.list[EMBRYO], np);
  assertState(np, EMBRYO);
  np->state = RUNNABLE;
  stateListAdd(&ptable.list[RUNNABLE], np);
  release(&ptable.lock);

  return pid;
}

#else
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i;
  uint pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);

  return pid;
}
#endif

#ifdef CS333_P3
//New implementation of exit
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);

      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  for(int i = EMBRYO; i < statecount; ++i)
  {
    p = ptable.list[i].head;
    while(p)
    {
      if (p -> parent == curproc) 
      {
        p -> parent = initproc;
        if (i == ZOMBIE)
          wakeup1(initproc);
      }
      p = p -> next;
    }
   }
 
  // Jump into the scheduler, never to return.
  stateListRemove(&ptable.list[RUNNING], curproc);
  assertState(curproc, RUNNING);
  curproc->state = ZOMBIE;
  stateListAdd(&ptable.list[ZOMBIE], curproc);
  sched();
  panic("zombie exit");
}

#else
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);

      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#endif

#ifdef CS333_P3
// New implementation of wait
int
wait(void)
{
  int havekids;
  uint pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;

    struct proc * p1 = ptable.list[EMBRYO].head;
    struct proc * p2 = ptable.list[SLEEPING].head;
    struct proc * p3 = ptable.list[RUNNABLE].head;
    struct proc * p4 = ptable.list[RUNNING].head; 
    struct proc * p = ptable.list[ZOMBIE].head;
  
    while(p1) // Embryo list
    {
      if(p1->parent == curproc)
        havekids = 1;  
      p1 = p1 -> next;
    }

    while(p2) // Sleeping list
    {
      if(p2->parent == curproc)
        havekids = 1;  
      p2 = p2 -> next;
    }

    while(p3) // Runnable list
    {
      if(p3->parent == curproc)
        havekids = 1;  
      p3 = p3 -> next;
    }

    while(p4) // Running list
    {
      if(p4->parent == curproc)
        havekids = 1;  
      p4 = p4 -> next;
    }

    while(p) // If child is in zombie list, remove it. 
    {
      if(p->parent == curproc) 
      {
        havekids = 1;
        int rc = stateListRemove(&ptable.list[ZOMBIE], p);
	    
        if(rc == -1)
          panic("ERROR NOT IN ZOMBIE"); 
	    
        assertState(p, ZOMBIE); 
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED; 
	    
        // add to unused list 
        stateListAdd(&ptable.list[UNUSED], p);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
      p = p->next;
    }
  
    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
  return 0;
}

#else
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids;
  uint pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif

#ifdef CS333_P3
// New implementation of scheduler
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
#ifdef PDX_XV6
  int idle;  // for checking if processor is idle
#endif // PDX_XV6

  for(;;){
    // Enable interrupts on this processor.
    sti();

#ifdef PDX_XV6
    idle = 1;  // assume idle unless we schedule a process
#endif // PDX_XV6
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    p = ptable.list[RUNNABLE].head;
    if(p)
    {
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
#ifdef PDX_XV6
      idle = 0;  // not idle this timeslice
#endif // PDX_XV6
      c->proc = p;
      switchuvm(p);
      int rc = stateListRemove(&ptable.list[RUNNABLE], p); //Removing process p from specific list
      if(rc == -1)
        panic("The process wasn't removed from runnable state");  
      assertState(p, RUNNABLE); 
      p->state = RUNNING;
      stateListAdd(&ptable.list[RUNNING], p);

#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
#endif

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
#ifdef PDX_XV6
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
#endif // PDX_XV6
  }
}

#else
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
#ifdef PDX_XV6
  int idle;  // for checking if processor is idle
#endif // PDX_XV6

  for(;;){
    // Enable interrupts on this processor.
    sti();

#ifdef PDX_XV6
    idle = 1;  // assume idle unless we schedule a process
#endif // PDX_XV6
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
#ifdef PDX_XV6
      idle = 0;  // not idle this timeslice
#endif // PDX_XV6
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

#ifdef CS333_P2
      p->cpu_ticks_in = ticks;
#endif

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
#ifdef PDX_XV6
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
#endif // PDX_XV6
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;

#ifdef CS333_P2
  // Capture running total
  p->cpu_ticks_total += ticks - p->cpu_ticks_in; //instance of ticks end - tick start
#endif

  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

#ifdef CS333_P3
// New implementation for yield
void
yield(void)
{
  struct proc *curproc = myproc();

  acquire(&ptable.lock);  //DOC: yieldlock
  assertState(curproc, RUNNING);
  stateListRemove(&ptable.list[RUNNING], curproc);
  curproc->state = RUNNABLE;
  stateListAdd(&ptable.list[RUNNABLE], curproc);
  sched();
  release(&ptable.lock);
}

#else
// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *curproc = myproc();

  acquire(&ptable.lock);  //DOC: yieldlock
  curproc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}
#endif

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

#ifdef CS333_P3
// New implementation of sleep
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    if (lk) release(lk);
  }

  stateListRemove(&ptable.list[RUNNING], p);
  assertState(p, RUNNING);
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  stateListAdd(&ptable.list[SLEEPING], p);

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#else
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    if (lk) release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}
#endif

#ifdef CS333_P3
// New implementation of wakeup1
static void
wakeup1(void *chan)
{
  struct proc *p;
  struct proc *current = ptable.list[SLEEPING].head;

  while(current)
  {
    if(current -> chan == chan && current -> state == SLEEPING)
    {
      p = current -> next;
      int rc = stateListRemove(&ptable.list[SLEEPING], current);
      if(rc == -1)
        panic("Wake up 1 error.");
      assertState(current, SLEEPING);
      current->state = RUNNABLE;
      stateListAdd(&ptable.list[RUNNABLE], current);
      current = p;
     }
   else
     current = current -> next;
  }
}

#else
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}


#ifdef CS333_P3
// New implementation of kill
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);

  for(int i = EMBRYO; i < statecount; ++i)
  {
    p = ptable.list[i].head;
    while(p)
    {
      if(p -> pid == pid)
      {
        p -> killed = 1;
        // Wake process from sleep if necessary.
        if(i == SLEEPING)
        {
          stateListRemove(&ptable.list[SLEEPING], p);
          assertState(p, SLEEPING);
          p->state = RUNNABLE;
          stateListAdd(&ptable.list[RUNNABLE], p);
         }
        release(&ptable.lock);
        return 0;
       }
     }
  }
  release(&ptable.lock);
  return -1;
}

#else
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#endif

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.

//Displays process information at initial executation. Code retreieved from http://web.cecs.pdx.edu/~markem/CS333/projects/p1
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  #if defined(CS333_P3P4)
  #define HEADER "\nPID\tName    UID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n"

  #elif defined(CS333_P3)
  #define HEADER "\nPID\tName    UID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n"

  #elif defined(CS333_P2)
  #define HEADER "\nPID\tName    UID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n"

  #elif defined(CS333_P1)
  #define HEADER "\nPID\tName    Elapsed\tState\tSize\t PCs\n"

  #else
  #define HEADER "\n"
  #endif

  cprintf(HEADER);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
  #if defined(CS333_P3P4)
    procdumpP3P4(p, state);
  #elif defined(CS333_P3)
    procdumpP3(p, state);
  #elif defined(CS333_P2)
    procdumpP2(p, state);
  #elif defined(CS333_P1)
    procdumpP1(p, state);
  #else
    cprintf("%d\t%s\t%s\t", p->pid, p->name, state);
  #endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

//Control-P implmeentation for Project 1. Wrapper for procdump.
#ifdef CS333_P1
void
procdumpP1(struct proc *p, char *state)
{
  int seconds;
  int millisec; 

  // Put equation for ticks here to make it into seconds
  seconds = ticks - p->start_ticks;     // Find the Seconds
  millisec = seconds%1000;               // Find the millisecond after decimal
  seconds = seconds/1000;               // Convert to actual seconds

  if(millisec < 10)
      cprintf("%d\t%s\t%d.00%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10

  if(millisec < 100)
      cprintf("%d\t%s\t%d.0%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10

  if(millisec > 100)
      cprintf("%d\t%s\t%d.%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
}
#endif


#ifdef CS333_P2
//Control-P implementation for Project 2. Wrapper for procdump.
void
procdumpP2(struct proc *p, char *state)
{
  // Put equation for ticks here to make it into seconds
  int seconds = ticks - p->start_ticks;     // Find the Seconds
  int millisec = seconds%1000;               // Find the millisecond after decimal
  seconds = seconds/1000;               // Convert to actual seconds

  int cpu_seconds = p->cpu_ticks_total/1000;    
  int cpu_millisec = p->cpu_ticks_total%1000;   
  cpu_seconds = seconds/1000;             

  cprintf("%d\t%s\t%d\t%d\t", p->pid, p->name, p->uid, p->gid);
  
  //Parent check. Are we in the INIT process?
  if(p->parent == NULL)
    cprintf("%d\t", p->pid);
  else
    cprintf("%d\t", p->parent->pid);

  if(millisec < 10)
    cprintf("%d.00%d\t", seconds, millisec);

  if(millisec < 100)
    cprintf("%d.0%d\t", seconds, millisec);

  if(millisec > 100)
    cprintf("%d.%d\t", seconds, millisec);

  if(cpu_millisec < 10)
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec < 100)
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec > 100)
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
}
#endif


//Control-P implementation for Project 3. Wrapper for procdump.
#ifdef CS333_P3
void
procdumpP3(struct proc *p, char *state)
{
// Put equation for ticks here to make it into seconds
  int seconds = ticks - p->start_ticks;     // Find the Seconds
  int millisec = seconds%1000;               // Find the millisecond after decimal
  seconds = seconds/1000;               // Convert to actual seconds

  int cpu_seconds = p->cpu_ticks_total/1000;    
  int cpu_millisec = p->cpu_ticks_total%1000;   
  cpu_seconds = seconds/1000;             

  cprintf("%d\t%s\t%d\t%d\t", p->pid, p->name, p->uid, p->gid);
  
  //Parent check. Are we in the INIT process?
  if(p->parent == NULL)
    cprintf("%d\t", p->pid);
  else
    cprintf("%d\t", p->parent->pid);

  if(millisec < 10)
    cprintf("%d.00%d\t", seconds, millisec);

  if(millisec < 100)
    cprintf("%d.0%d\t", seconds, millisec);

  if(millisec > 100)
    cprintf("%d.%d\t", seconds, millisec);

  if(cpu_millisec < 10)
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec < 100)
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec > 100)
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
}
#endif

#ifdef CS333_P2
// Set the UID of the process
int
setuid(uint uid)
{
  acquire(&ptable.lock);
  myproc()->uid = uid;
  release(&ptable.lock);
  return 1;
}

// Set the GID of the process
int
setgid(uint gid)
{
  acquire(&ptable.lock);
  myproc()->gid = gid;
  release(&ptable.lock);
  return 1;
}

// Displays active processes
int
getprocs(uint max, struct uproc *table)
{
  acquire(&ptable.lock);

  int count = 0;
  
  for(int i = 0; i < max && i < NPROC; ++i) //Tables may vary in sizes. Prevents going out of bounds.
  {
    if(ptable.proc[i].state != UNUSED && ptable.proc[i].state != EMBRYO) //These states are inactive
    {
      table[i].pid = ptable.proc[i].pid;
      table[i].uid = ptable.proc[i].uid; 
      table[i].gid = ptable.proc[i].gid;

      if(ptable.proc[i].parent == 0)
        table[i].ppid = ptable.proc[i].pid;
      else
        table[i].ppid = ptable.proc[i].parent->pid;

      table[i].elapsed_ticks = ticks - ptable.proc[i].start_ticks;
      table[i].CPU_total_ticks = ptable.proc[i].cpu_ticks_total;

      if(ptable.proc[i].state == SLEEPING)
        safestrcpy(table[i].state, "sleep", sizeof("sleep"));
      if(ptable.proc[i].state == RUNNABLE)
        safestrcpy(table[i].state, "runnable", sizeof("runnable"));
      if(ptable.proc[i].state == RUNNING)
        safestrcpy(table[i].state, "running", sizeof("running"));
      if(ptable.proc[i].state == ZOMBIE)
        safestrcpy(table[i].state, "zombie", sizeof("zombie"));

      table[i].size = ptable.proc[i].sz; 
      safestrcpy(table[i].name, ptable.proc[i].name, sizeof(ptable.proc[i].name));
      ++count;
    }
  }
  release(&ptable.lock);
  return count; //How large uproc *table is
}
#endif
