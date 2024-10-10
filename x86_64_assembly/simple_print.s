.section .data
my_string:
	.ascii "Hello world!\n"
end_of_my_string:

.equ MY_STRING_LENGTH, end_of_my_string - my_string

.section .text
.globl _start
_start:
	movq $1, %rax
	movq $1, %rdi
	movq $my_string, %rsi
	movq $MY_STRING_LENGTH, %rdx
	syscall

	movq $0x3c, %rax
	movq $0, %rdi
	syscall
