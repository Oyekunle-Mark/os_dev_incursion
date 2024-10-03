.section .text
.globl _start
_start:
	# move the base to %rbx
	movq $2, %rbx
	# move the exponent to %rcx(counter register)
	movq $3, %rcx
	# start accumulator at 1
	movq $1, %rax
	cmpq $0, %rcx
	je comple
mainloop:
	mulq %rbx
	loopq mainloop
complete:
	movq %rax, %rdi
	movq $60, %rax
	syscall
