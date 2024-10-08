.section .data
my_test:
	.ascii "This is a string of characters.\0"

.section .text
.globl _start
_start:
	movq $my_test, %rbx
	movq $0, %rdi
main_loop:
	movb (%rbx), %al

	cmpb $0, %al
	je finish

	cmpb $'a', %al
	jb loop_control

	cmpb $'z', %al
	ja loop_control

	incq %rdi
loop_control:
	incq %rbx
	jmp main_loop
finish:
	movq $60, %rax
	syscall
