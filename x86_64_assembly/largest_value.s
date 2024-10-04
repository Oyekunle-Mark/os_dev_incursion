# this program finds the largest value in an array stored in memory
.section .data
number_of_numbers:
	.quad 7
numbers:
	.quad 5, 20, 33, 80, 52, 10, 1

.section .text
.globl _start
_start:
	movq number_of_numbers, %rcx
	movq $0, rdi

	cmp $0, %rcx
	je endloop
myloop:
	movq numbers-8(,%rcx,8), %rax
	cmp %rdi, %rax
	jbe loopcontrol

	movq %rax, %rdi
loopcontrol:
	loopq myloop
endloop:
	movq $60, %rax
	syscall
