# The Memory Hierarchy

## Storage Technologies

#### SRAM vs DRAM
```
-----------------------------------------------------------------------------------------------------------------
     | transitors/bit | access time | persistent | sensitive | cost  |  applications             | size
-----------------------------------------------------------------------------------------------------------------
SRAM | 6 (bitstable)  | 1x          | Y          | N         | 1000x |  cache memory             | tens of MBs
-----------------------------------------------------------------------------------------------------------------
DRAM | 1 (capacitor)  | 10x         | N          | Y         | 1x    |  main memory/frame buffers| hundreds of MBs
-----------------------------------------------------------------------------------------------------------------
```
#### CPU `<==>` Bus Interface `<===>` (system bus) I/O bridge `<--->` (memory bus) main memory
* Steps for `movq A, %rax` (Bus interface initiates `read transaction`)
  * CPU places address `A` on system bus
  * main memory senses address signal on memory bus -> read `A` from memory bus ->  fetches data from DRAM => I/O bridge translates memory bus signal to system bus signal -> passes it along to system bus
  * CPU senses data on system bus, reads data from system bus, copies data to `%rax`
* Steps for `movq %rax,A` (Bus interface initiates `write transaction`)
  * CPU places address `A` on system bus => memory reads address from memory bus -> waits for data.
  * CPU copies data of `%rax` to system bus
  * main memory reads data from memory bus -> store data in DRAM.

#### MMIO (memory-mapped I/O)
* each device is mapped to >= 1 I/O ports
* e.g., CPU initiates a disk (port `0xa0`) read
  * 1st (store) instruction: sends a command word telling disk to initiate a read, w/o parameters (e.g., whether to interrupt CPU when read finished)
  * 2nd (store) instruction: indicates logic block number that should be read
  * 3rd (store) instruction: indicates main memory address where contents of disk sector should be stored
* after disk controller receives read command from CPU, DMA is conducted w/o CPU

## Locality
* Programs repeatedly referencing same variables -- good `temporal locality`
* strid-k, smaller k, better `spatial locality`
* loops have good `temporal` and `spatial locality`

## The Memory Hierarchy
* cold miss/compulsory miss
* conflict miss

## Cache Memories
* index with middle bits
* update write-cache copy in next level of memory hierarchy
  * write-through (write cache to next lower level)
  * write-back (write only when evicted, `dirty bits`)
* deal with write misses
  * write-allocate --- write-back
  * no-write-allocate --- write-through
* cache categories
  * i-cache (read-only)
  * d-cache
  * unified cache

## Writing Cache-Friendly Code
* cache lines, sets, and blocks

## Putting it Together: The Impact of Caches on Program Performance
TODO [chapter_06](chapter_06)

## Summary
