# find if a number(in %rax) is even or odd
# exits with 1 if event, 0 if odd
.section .text
.globl _start
_start:
	movq $34357, %rax
	movq $2, %rsi
	divq %rsi

	cmpq $0, %rdx
	je even

	movq $0, %rdi
	jmp exit
even:
	movq $1, %rdi 
exit:
	movq $60, %rax
	syscall
