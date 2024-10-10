.section .data
current_time:
	.quad 0
.section .text
.globl _start
_start:
	movq $0xc9, %rax
	movq $current_time, %rdi
	syscall

	movq current_time, %rdx
	addq $5, %rdx
time_loop:
	movq $0xc9, %rax
	movq $current_time, %rdi
	syscall

	cmpq %rdx, current_time
	jb time_loop
finish:
	movq $0x3c, %rax
	movq $0, %rdi
	syscall

