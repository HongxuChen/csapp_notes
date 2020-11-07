# Exceptional Control Flow
ECF:
* hardware: abrupt control
* operating system: context switch
* application: signal

## Exceptions
TODO (plantuml to draw sequence)
After exception handling, these can happen
* handler returns control to current instruction;
* handler returns control to next instruction;
* handler aborts the program.

classes of exceptions:
* interrupts
* traps & system calls
* faults
* aborts

Linux/x86-64 faults & aborts
* divide error
* general protection fault
* page fault
* machine check

Linux/x86-64 system calls
```
----------------------------------------------------------------
Number| Name   | Description
----------------------------------------------------------------
0     | read   | read file
----------------------------------------------------------------
1     | write  | write file
----------------------------------------------------------------
2     | open   | open file
----------------------------------------------------------------
3     | close  | close file
----------------------------------------------------------------
4     | stat   | get file info
----------------------------------------------------------------
9     | mmap   | map memory page to file
----------------------------------------------------------------
12    | brk    | reset the top of heap
----------------------------------------------------------------
32    | dup2   | copy file descriptor
----------------------------------------------------------------
33    | pause  |  suspend process until signal arrives
----------------------------------------------------------------
37    | alarm  | schedule delivery of alarm signal
----------------------------------------------------------------
39    | getpid | get process ID
----------------------------------------------------------------
57    | fork   | create process
----------------------------------------------------------------
59    | execve | execute a program
----------------------------------------------------------------
60    | _exit  | terminate a process
----------------------------------------------------------------
61    | wait4  |  wait for a process to terminate
----------------------------------------------------------------
62    | kill   | send signal to process
----------------------------------------------------------------
```

## Processes
* Logical Control Flow
* Concurrent Flow
* private address space
* user and kernel modes
* context switches

## System Call Error Handling
* `errno` and `strerror`

## Process Control
* return code: <=128 vs >128
* `fork-execve` pattern

## Signals
* `man 3 signal` to see the signal lists (used by `kill`  syscall, `man 2 kill`)
* signal received ---> signal handled --> return to next instruction
* default sigactions:
  * The process terminates.
  * The process terminates and dumps core.
  * The process stops (suspends) until restarted by a SIGCONT signal.
  * The process ignores the signal.
* `sighandler_t signal(int signum, sighandler_t handler)` changes the actions:
  * `handler` is `SIG_IGN`, `signum` ignored
  * `handler` is `SIG_DFL`, `signum` reverts to default
  * otherwise, `handler` is a user-defined function -- signal handler
* implicit blocking signals due to pending
* `sigprocmask` to explicitly block/unblock signals
* writing signal handlers
  * keep handlers as simple as possible
  * call only async-signal-safe functions
  * save and store errno
  * protect access to shared global data structures
  * declare global variables with `volatile`
  * declare flags with `sig_atomic_t`
* C++ exceptions are high-level, structured versions of `setjmp`(try) and `longjmp`(throw)


## Tools for Manipulating Processes
* strace/ps/top
* `/proc`
