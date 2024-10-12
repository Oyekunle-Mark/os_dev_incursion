.section .text
.globl _start
_start:
	movq $4, %rdi
	call factorial

	movq %rax, %rdi
	movq $60, %rax
	syscall
