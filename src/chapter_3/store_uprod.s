	.file	"store_uprod.c"
	.text
	.globl	store_uprod
	.type	store_uprod, @function
store_uprod:
.LFB4:
	.cfi_startproc
	endbr64
	movq	%rsi, %rax    # -- arg2 to %rax 
	mulq	%rdx          # -- unsigned multiply of %rax by %rdx(arg3), results to %rdx:%rax 
	movq	%rax, (%rdi)  # -- low bits to %rdi(low arg1)
	movq	%rdx, 8(%rdi) # -- high bits to %rdi+8(high arg2)
	ret
	.cfi_endproc
