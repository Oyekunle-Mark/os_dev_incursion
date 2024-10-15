.section .data
prompt_format:
	.ascii "Enter two numbers separated by spaces, then press return.\n\0"
scan_format:
	.ascii "%d %d\0"
result_format:
	.ascii "The result is %d.\n\0"

.equ LOCAL_NUMBER, -8
.equ LOCAL_EXPONENT, -16

.section .text
.globl main
main:
	enter $16, $0

	# stdout is a memory location that holds a
	# FILE* to standard output
	movq stdout, %rdi
	movq $prompt_format, %rsi
	# zero %rax by xor-ing it with itself
	xorq %rax, %rax
	call fprintf

	# stdin is a memory location that holds a
	# FILE* to standard input
	movq stdin, %rdi
	movq $scan_format, %rsi
	# we pass the address of our stack locations so the values
	# obtained from the user are loaded there
	leaq LOCAL_NUMBER(%rbp), %rdx
	leaq LOCAL_EXPONENT(%rbp), %rcx
	xorq %rax, %rax
	call fscanf

	# move the values obtained from user(which are on the stack)
	# to %rdi and %rsi so exponent can use them
	movq LOCAL_NUMBER(%rbp), %rdi
	movq LOCAL_EXPONENT(%rbp), %rsi
	call exponent

	movq stdout, %rdi
	movq $result_format, %rsi
	movq %rax, %rdx
	xorq %rax, %rax
	call fprintf

	# set return value to 0
	xorq %rax, %rax

	leave
	ret
