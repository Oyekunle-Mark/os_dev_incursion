# finds the factorial of a number
# accepts a single number of which the
# factorial is to computed and returned
# in %rax
.section .text
.globl factorial
factorial:
	# create a stack frame 16 byte large
	enter $16, $0
	# check if factorial was called with 1 as parameter
	cmpq $1, %rdi
	# if not jump to continue
	jne continue

	# factorial was called with 1
	movq $1, %rax
	# destroy the stack frame
	leave
	# pop return address and jump there
	ret
continue:
	# move parameter to the stack
	movq %rdi, -8(%rbp)
	# decrement %rdi
	decq %rdi
	# recursively call factorial with argument - 1
	call factorial

	# multiply the return of the call to factorial above with
	# value of %rdi saved in stack
	mulq -8(%rbp)
	# destroy stack
	leave
	# return
	ret
