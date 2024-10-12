# this function finds the exponent of a number
# the first parameter is the base, the second the exponent

.globl exponent
.type exponent, @function

.section .text
exponent:
	enter $16, $0
	movq $1, %rax
	movq %rsi, -8(%rbp)
main_loop:
	mulq %rdi
	decq -8(%rbp)
	jnz mainloop
complete:
	leave
	ret
