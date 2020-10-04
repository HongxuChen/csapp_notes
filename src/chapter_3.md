# Machine-Level Representation of Programs

> With modern optimizing compilers, the generated code is usually at least as efficient as what a skilled assembly-language programmer would write by hand.

## A Historical Perspective
```
|-------------------------------------------------------------------------------------|
|processor       | features                                                           |
|----------------|--------------------------------------------------------------------|
| 8086           |1978. single-chip, 16bit. 8087 supprts fp                           |
|----------------|--------------------------------------------------------------------|
| 80286          |1982. more (obsolete) addressing mode. form basis of IBM PC-AT      |
|----------------|--------------------------------------------------------------------|
| i386           |1985. 32bit. flat addressing model. fully support UNIX              |
|----------------|--------------------------------------------------------------------|
| i486           |1989. improved performance, fp supports                             |
|----------------|--------------------------------------------------------------------|
| Pentium        |1993. improved performance                                          |
|----------------|--------------------------------------------------------------------|
|PentiumPro      |1995. P6 microarchitecture. "conditional move" instructions         |
|----------------|--------------------------------------------------------------------|
|Pentium/MMX     |1997. integer vector instructions (<=64bit)                         |
|----------------|--------------------------------------------------------------------|
|Pentium II      |1997. improved P6                                                   |
|----------------|--------------------------------------------------------------------|
|Pentium III     |1999. SSE (integer/fp vector, <=128bit); integrate level-2 cache    |
|----------------|--------------------------------------------------------------------|
|Pentium 4       |2000. SSE2 (double fp) with 144 new instructions                    |
|----------------|--------------------------------------------------------------------|
|Pentium 4E      |2004. hyperthreading. EM64T                                         |
|----------------|--------------------------------------------------------------------|
|Core 2          |2006. P6-like microarchitecture. multi-core w/o hyperthreading      |
|----------------|--------------------------------------------------------------------|
|i7,Nehalem      |2008. combine multi-core & hyperthreading; 2progs/core; 4cores/chip |
|----------------|--------------------------------------------------------------------|
|i7,Sandy Bridge |2011. AVX(extension to SSE, <=256bit)                               |
|----------------|--------------------------------------------------------------------|
|i7,Haswell      |2013. AVX2                                                          |
|----------------|--------------------------------------------------------------------|
```

## Program Encodings

Process states:
* program counter(PC): `%rip` in x86-64
* integer register file: 16 named locations storing 64bit addresses/integers
* condition code registers: most recently executed arithmetic/logic instruction
* vector registers: integers/fps

#### For x86-64 integer registers, usage conventions are:
* Return value (`rax`, `eax`, `ax`, `al`)
* Callee saved (`rbx`, `ebx`, `bx`, `bl`)
* 4th argument (`rcx`, `ecx`, `cx`, `cl`)
* 3rd argument (`rdx`, `edx`, `dx`, `dl`)
* 2nd argument (`rsi`, `esi`, `si`, `sil`)
* 1st argument (`rdi`, `edi`, `di`, `dil`)
* Callee saved (`rbp`, `ebp`, `bp`, `bpl`)
* Stack pointer (`rsp`, `esp`, `sp`, `spl`)
* 5th argument (`r8`, `r8d`, `r8w`, `r8b`)
* 6th argument (`r9`, `r9d`, `r9w`, `r9b`)
* Caller saved (`r10`, `r10d`, `r10w`, `r10b`)
* Caller saved (`r11`, `r11d`, `r11w`, `r11b`)
* Callee saved (`r12`, `r12d`, `r12w`, `r12b`)
* Callee saved (`r13`, `r13d`, `r13w`, `r13b`)
* Callee saved (`r14`, `r14d`, `r14w`, `r14b`)
* Callee saved (`r15`, `r15d`, `r15w`, `r15b`)

#### Current x86-64 machines, upper 16bits are ALL zero -- virtual address range: [0,\\(2^{48}\\)].

```c
// mstore.c
{{#include chapter_3/mstore.c}}
```

```C
// gcc -Og -S mstore.c -o mstore_gcc_O0.s
{{#include chapter_3/mstore_gcc_O0.s}}
```

```C
// clang -Og -S mstore.c -o mstore_clang_O0.s
{{#include chapter_3/mstore_clang_O0.s}}
```

```C
// gcc -Og -c mstore.c -o mstore_gcc_O0.o
// objdump -d mstore_gcc_O0.o > mstore_gcc_O0.objdump
{{#include chapter_3/mstore_gcc_O0.objdump}}
```

```C
// clang -Og -emit-llvm -S mstore.c -o mstore_clang_O0.ll
{{#include chapter_3/mstore_clang_O0.ll}}
```

## Data Formats

```
// size of data types in x86-64
---------------------------------------------------------------
C types     Inel types        Assembly suffixes       Bytes
---------------------------------------------------------------
char        byte                      b                 1
short       word                      w                 2
int         double word               l                 4
long        quad word                 q                 8
char *      quad word                 q                 8
            oct word                                   16
float       single precision          s                 4
double      double precision          l                 8
---------------------------------------------------------------
```

## Accessing Information

| type      | Form                  | Operand value                     | Name              |
| ---       | ---                   | ---                               | ---               |
| Immediate | \\($Imm\\)            | \\(Imm\\)                         | Immediate         |
| Register  | \\(r_a\\)             | \\(R[r_a]\\)                      | Register          |
| Memory    | \\(Imm\\)             | \\(M[Imm]\\)                      | Absolute          |
| Memory    | \\((r_a)\\)           | \\(M[R[r_a]]\\)                   | Indirect          |
| Memory    | \\(Imm(r_b)\\)        | \\(M[Imm+R[r_b]]\\)               | Base+displacement |
| Memory    | \\((r_b, r_i)\\)      | \\(M[R[r_b]+R[r_i]\\)             | Indexed           |
| Memory    | \\(Imm(r_b, r_i)\\)   | \\(M[Imm+R[r_b]+R[r_i]\\)         | Indexed           |
| Memory    | \\((,r_i, s)\\)       | \\(M[R[r_i]\cdot s]\\)            | Scaled Indexed    |
| Memory    | \\(Imm(,r_i, s)\\)    | \\(M[Imm+R[r_i]\cdot s]\\)        | Scaled Indexed    |
| Memory    | \\((r_b,r_i, s)\\)    | \\(M[R[r_b]+R[r_i]\cdot s]\\)     | Scaled Indexed    |
| Memory    | \\(Imm(r_b,r_i, s)\\) | \\(M[Imm+R[r_b]+R[r_i]\cdot s]\\) | Scaled Indexed    |

#### Push and Pop
* `pushq S`(`S` can be a register value like `%rbp`): increase stack (\\(R[\\%rsp]\leftarrow R[\\%rsp]-8\\) for x86-64, `sub $8,%rsp`) and store the value `S` into the memory pointed by the stack register (\\(M[R[\\%rsp]]\leftarrow S\\), `movq %rbp, %rsp`)
* `popq D` (`D` can be a regiser value like `%rax`): store the stack pointer pointed value in memory to `D` (\\(D\leftarrow M[R[\\%rsp]]\\), `movq (%rsp),%rax`) and decrease stack (\\(R[\\%rsp]\leftarrow R[\\%rsp]+8\\), `addq $8,%rsp`)

#### Arithmetic and Logical Operations
* `leaq` can perform simple `add` or `mul` operations
* two's-component arithmetic is the preferred for signed integer arithmetic
* Special arithmetic operations can be implemented with corperations of several registers
```C
// scale.c
{{#include chapter_3/scale.c}}

// scale.s
{{#include chapter_3/scale.s}}
```

```C
// store_uprod.c
{{#include chapter_3/store_uprod.c}}

// store_uprod.s
{{#include chapter_3/store_uprod.s}}
```

```C
// remdiv.c
{{#include chapter_3/remdiv.c}}

// remdiv.s
{{#include chapter_3/remdiv.s}}
```

## Control

#### Control Codes (condition code register/FLAG register)
* Flags
  * `CF`: carry flag, overflow for unsigned operations
  * `ZF`: zero flag
  * `SF`: sign flag
  * `OF`: overflow flag, overflow for two-complement's operations
* instructions
  * cmp S1, S2 (`S2 - S1`), `sub` w/o updating destinations
  * test S1, S2 (`s1 & s2`), `and` w/o updating destinations. two same operands;  one masking
  * set D
  * jump Label/*Operand

```C
// comp.c
{{#include chapter_3/comp.c}}

// comp.s
{{#include chapter_3/comp.s}}
```

```
// jump instructions
|---------------------------------------------------------------------------|
| Instruction | Synonym  | Jump condition | Description                     |
|---------------------------------------------------------------------------|

// conditional move instructions
|---------------------------------------------------------------------------|
| Instruction | Synonym  | Move condition | Description                     |
|---------------------------------------------------------------------------|
```

#### C constructs
* Loops
  * do-while
  * while
  * for
* switch

## Procedures
`P \rightarrow Q`, actions to be done
* pass control: program counter (`rsp`); runtime stack
  * `call Label`, `call *Operand`, `ret`
* pass data: parameters, returns
  * args: `rdi`, `rsi`, `rdx`, `rcx`, ...
  * callee-saved: `rbx`, `rbp`, `r13`, `r14`, `r15` (`Q` should preserve)
  * caller-saved: `r10`, `r11`, `r12` (can be modified by any function)
* allocate&deallocate memory: for local variables (on stack)
  * some local data must be stored in memory
    * not enough registers
    * need to generate an address for `&`
    * access arrays/structs

## Array Allocation and Access
```
|---------------------------------------------------------------------------|
| Expression | Type  | Value | Assembly code                                |
|---------------------------------------------------------------------------|
```

## Heterogeneous Data Structures
Representation:
* structs
* union
* alignment
  * improves efficiency
  * program correctness (SSE instructions)

## Combining Control and Data in Machine-Level Programs
* See [GDB cheatsheet](chapter_3/GDB_CheatSheet.pdf)
* buffer-overflow

## Floating-Point Code

#### others
* thanks to branch prediction logic, code based on conditional data transfers can outperform code based on conditional control transfers

