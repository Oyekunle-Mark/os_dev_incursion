.globl _start
.section .text
_start:
	movq $3, %rdi
	movq %rdi, %rax
	# add %rdi to %rax, storing the result in %rax
	addq %rdi, %rax
	# multiply %rdi with %rax, leaving the result in %rax
	# %rax in mul operations is implicit and does not need to be provided
	mulq %rdi
	movq $2, %rdi
	addq %rdi, %rax
	movq $4, %rdi
	mulq %rdi
	# %rdi is the exit system call(made later) exit code
	movq %rax, %rdi

	# set 60(exit system call number)
	movq $60, %rax

	# perform the exit call
	syscall
