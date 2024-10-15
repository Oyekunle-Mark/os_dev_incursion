.section .data
output:
	.string "Hello\n"

.section .text
.globl main
main:
	enter $0, $0

	movq stdout@GOTPCREL(%rip), %rdi
	movq (%rdi), %rdi
	leaq output(%rip), %rsi
	call fprintf@plt

	xorq %rax, %rax

	leave
	ret
