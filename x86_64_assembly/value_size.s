.section .text
.globl _start
_start:
	# move 16 bit binary into %bx(16 bit register of rbx)
	movw $0b0000000100000010, %bx
	# add high and low bytes of %bx, leaving the result in %bl
	addb %bh, %bl
	# zero the high byte of %bx
	movb $0, %bh

	# move %rbx(which includes the 16 bit region %bx) into %rdi as exit code
	movq %rbx, %rdi

	# make exit syscall
	movq $60, %rax
	syscall
