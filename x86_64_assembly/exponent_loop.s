.section .text
.globl _start
_start:
	# move the base to %rbx
	movq $2, %rbx
	# move the exponent to %rcx(counter register)
	movq $3, %rcx
	# start accumulator at 1
	movq $1, %rax

	# if exponent is zero, we can wrap up the program
	cmpq $0, %rcx
	# jump if result of last comparison set the zero flag to 0
	je comple
mainloop:
	# multiple %rax with %rbx
	mulq %rbx
	# the loopq command decrements %rcx(counter register)
	# and jumps to the label if %rcx is zero(as a result of the decrement operation)
	loopq mainloop
complete:
	# use exit syscall to view result
	movq %rax, %rdi
	movq $60, %rax
	syscall
