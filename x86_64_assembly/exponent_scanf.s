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

	movq stdout, %rdi
	movq $prompt_format, %rsi
	xorq %rax, %rax
	call fprintf

	movq stdin, %rdi
	movq $scan_format, %rsi
	leaq LOCAL_NUMBER(%rbp), %rdx
	leaq LOCAL_EXPONENT(%rbp), %rcx
	xorq %rax, %rax
	call fscanf

	movq LOCAL_NUMBER(%rbp), %rdi
	movq LOCAL_EXPONENT(%rbp), %rsi
	call exponent

	movq stdout, %rdi
	movq $result_format, %rsi
	movq %rax, %rdx
	xorq %rax, %rax
	call fprintf

	xorq %rax, %rax

	leave
	ret
