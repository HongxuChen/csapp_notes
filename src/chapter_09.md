# Virtual Memory

## Address Space
An ordered set of nonnegative integer addresses

## VM as a Tool for Caching
* `virtual pages`: fixed size virtual memory
  * unallocated: no data associated (do not occupy space on disk)
  * cached: allocated & cached in physical memory
  * uncached:  alllocated & not cached in physical memory
* `page fault`: a DRAM cache miss
  * swap/page in
  * swap/page out

## VM as a Tool for Memory Management
VM simplifies `linking`, `loading` and `sharing`
* linking: All processes use the same basic format for the memory images, due to separate address space
* loading: allocate memories for `.text` and `.data`. loader does not acutally copy data from disk to memory, but paged in automatically and on-demand the VM the first time each page is referenced. -- `mmap` (memory mapping)
* `sharing`: e.g., kernal code shared among user-space applications
* `memory allocation`: mallocated memories may be scattered randomly in physical memory

## VM as a Tool for Memory Protection
Providing separate address spaces isolates private memories of different processes.

## Address Translation
* \\(MAP:VAS\rightarrow PAS\cup\emptyset\\), where \\(\emptyset\\) corresponds to page fault.
  * page hit: only hardware
  * page fault: hardware + OS
* TODO: p9.12 with plantuml
* speed up address translation with TLB (no need L1 cache)

## Case Study: The Intel Core i7/Linux Memory System
* PT and the Linux names:
  * L1 PT: page global directory
  * L2 PT: page upper directory
  * L3 PT: page middle directory
  * L4 PT: page table
* optimizing address translation: overlap 1) translating VA to PA 2) passing PA to L1 cache
* Linux `vm_area_struct`
  * `vm_start`
  * `vm_end`
  * `vm_prot`: read/write permissions for all pages in this area
  * `vm_flags`: whether the pages in this area are shared with other processes private to this area
  * `vm_next`: next area struct in the list
* When MMU triggers a page fault while trying to translate virtual address \\(A\\) in Linux
  * check whether \\(A\\) is illegal (`vm_area_struct`); segfault if illegal
  * check whether the process has the permission to read/write/execute the page in this area
  * swap out a victim page and replace

## Memory Mapping
* Linux area can be mapped to 2 types of files
  * regular file (demand paging)
  * anonymous file (demand-zero pages)
* shared area vs private area
* `fork` -- copy-on-write
* `execve`
  * delete existing user areas
  * map private areas
  * map shared areas
  * set PC
* `void *mmap(void *start, size_t length, int prot, int flags, int fd, off_t offset)`

## Dynamic Memory Allocation
* Allocation
  * Explicit allocation (`malloc`, `calloc`, `realloc`)
  * Implicit allocation (GC)

Implementation Issues:
* Free Blocks: implicit free list (linked implicitly by size fields in the headers)
* Placing Allocated Blocks
  * first fit
  * next fit
  * best fit
* Splitting Free Blocks
* Coalescing Free Blocks (combat false fragmentation)


## Garbage Collection
* `directed reachability graph`


## Common Memory-Related Bugs in C Programs
* Dereferencing Bad Pointers
* Reading Uninitialized Memory
* Allowing Stack Buffer Overflows
* Assuming That Pointers and the Objects They Point to Are the Same Size
* Making Off-by-One Errors
* Referencing a Pointer Instead of the Object It Points To
* Misunderstanding Pointer Arithmetic
* Referencing Nonexistent Variables
* Referencing Data in Free Heap Blocks
* Introducing Memory Leaks
