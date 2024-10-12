# finds the factorial of a number
# accepts a single number of which the
# factorial is to computed and returned
# in %rax
.section .text
.globl factorial
factorial:
	enter $16, $0
	cmpq $1, %rdi
	jne continue

	movq $1, %rax
	leave
	ret
continue:
	movq %rdi, -8(%rbp)
	decq %rdi
	call factorial

	mulq -8(%rbp)

	leave
	ret
