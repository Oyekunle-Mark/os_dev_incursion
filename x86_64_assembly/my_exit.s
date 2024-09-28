# This program does very little
# It only calls the exit system call

.globl _start
.section .text
_start:
	movq $60, %rax
	movq $3, %rdi
	syscall

