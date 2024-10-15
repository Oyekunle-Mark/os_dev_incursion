.section .text
.globl _start
_start:
	# call exponent with 3 for base
	# and 2 for exponent
	movq $3, %rdi
	movq $2, %rsi
	# call is equivalent to:
	# 1. pushq %rip
	# 2. jmp exponent
	call exponent

	# return value of exponent is in %rax
	movq %rax, %rdi
	movq $60, %rax
	syscall
