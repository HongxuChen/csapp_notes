	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 15	sdk_version 10, 15, 6
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	xorl	%edi, %edi
	callq	_time
	testq	%rax, %rax
	je	LBB0_1
LBB0_2:
	leaq	L_.str.1(%rip), %rdi
	callq	_puts
	xorl	%eax, %eax
	popq	%rbp
	retq
LBB0_1:
	leaq	L_.str(%rip), %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	_printf
	jmp	LBB0_2
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"

L_.str.1:                               ## @.str.1
	.asciz	"a"

.subsections_via_symbols
