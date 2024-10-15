.section .data
value:
	.quad 6
output_format:
	.string "The square of %d is %d\n"

.section .text
.globl main
main:
	enter $0, $0

	movq value, %rdi
	call square_me

	movq stdout, %rdi
	leaq output_format, %rsi
	movq value, %rdx
	movq %rax, %rcx
	call fprintf

	leave
	ret
