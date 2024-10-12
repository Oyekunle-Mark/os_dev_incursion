.section .text
.globl _start
_start:
	movq $3, %rdi
	movq $2, %rsi
	call exponent

	movq %rax, %rdi
	movq $60, %rax
	syscall
