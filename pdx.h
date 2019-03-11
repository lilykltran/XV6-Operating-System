/*
 * This file contains types and definitions for Portland State University.
 * The contents are intended to be visible in both user and kernel space.
 */

#ifndef PDX_INCLUDE
#define PDX_INCLUDE

#define TRUE 1
#define FALSE 0
#define RETURN_SUCCESS 0
#define RETURN_FAILURE -1

#define NUL 0
#ifndef NULL
#define NULL NUL
#endif  // NULL

#define TPS 1000   // ticks-per-second
#define SCHED_INTERVAL (TPS/100)  // see trap.c

#define NPROC  64  // maximum number of processes -- normally in param.h

#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

#define UID 0
#define GID 0
#define unused 0
#define embryo 1
#define sleeping 2
#define runnable 3
#define running 4
#define zombie 5
#define statecount NELEM(states)
#define BUDGET 300
#define TICKS_TO_PROMOTE 300
#define MAXPRIO 6

#endif  // PDX_INCLUDE
