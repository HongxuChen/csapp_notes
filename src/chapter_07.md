# Linking

## Compiler Drivers
Workflow
* preprocessing: `cpp`
* compilation: `cc1`
* assembly: `as`
* link: `ld`

## Static Linking
* symbol resolution: function/global variable/static variable
* relocation: *blindly* relocate using `relocation entries`

## Object Files
* `.o`: relocatable object file
* `.out`: executable object
* `.so`: shared object

## Relocatable Object Files
* `.text`: machine code
* `.rodata`: read-only data
* `.data`: initialized global/static variables
* `.bss`: unintialized or zero-value global/static variables
* `.symtab`: symbol table, `-g` or relocatable object files
* `rel.text`: relocation entries in `.text` to be modified (external functions/global variables) during link
* `rel.data`: relocation entries for global variables referenced/defined in this module
* `.debug`: `-g`
* `.line`: line debug mappings, `-g`
* `.strtab`: string table for symbol tables in `.symtab` and `.debug`

## Symbols and Symbol Tables
* global liker symbols: defined by this module: nonstatic C functions and global variables
* externals: nonstatic C functions and global variables defined in other modules
* local symbols: static C functions and static global variables (only visiable in this module)

## Symbol Resolution
* global symbols can be weak/strong
* link rules: same name globals <=1 strong; prefer strong; choose any weak
* gcc `-fno-common` option
* static link only copies needed object inside static library
  * place static libraries at the end of command line
  * libraries can be repeated

## Relocation
* sections and symbol definitions
* symbol references within sections
* relocating:
  * PC-Relative References
  * Absolute References

## Executable Object Files
* no `.rel*` any more
* starting address `vaddr`: `vaddr mod align = off mod align`

## Loading Executable Object Files
* create the memory image during loading (process, virtual memory, memory mapping)

## Dynamic Linking with Shared Libraries
* shared libraries: ONE `.so` for a particular library; `.text` of a shared library can be shared by different running processes

## Loading and Linking Shared Libraries from Applications
* linux system:
  * `dlopen`
  * `RTLD_GLOBAL`, `RTLD_NOW`/`RTLD_LAZY`
  * `dlsym`
  * `dlclose`
  * `dlerror`

## Position-independent Code (PIC)
* PIC: code that can be loaded w/o relocations
  * PIC data references
    * GOT: beginning of data segment
  * PIC function calls

## Library Interposition
* compile-time interposition (`include headers`)
* link-time interposition (`-Wl,option`)
* run-time interposition (`LD_PRELOAD`)

## Tools for Manipulating Object Files
