.section .text
.globl _start
_start:
	# parameter to factorial is 4
	movq $4, %rdi
	call factorial

	# the value returned by factorial is passed as
	# the exit code to the exit syscall
	movq %rax, %rdi
	movq $60, %rax
	syscall
