.globl square_me
.type square_me, @function

.section .text
square_me:
	movq %rdi, %rax
	imulq %rdi
	ret
