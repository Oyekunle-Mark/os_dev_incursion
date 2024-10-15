.section .text
.globl _start
_start:
	# move binary 1101(decimal 13) into rdi as status code of exit syscall
	movq $0b1101, %rdi
	# make exit syscall so the decimal value of %rdi gets called
	movq $60, %rax
	syscall
