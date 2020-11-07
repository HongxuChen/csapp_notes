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
