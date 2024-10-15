.section .data
ten:
	.quad 10

.section .text
.globl mult_by_ten
.type mult_by_ten, @function
mult_by_ten:
	# pc relative addressing of the label ten
	movq ten(%rip), %rax
	imulq %rdi
	ret
