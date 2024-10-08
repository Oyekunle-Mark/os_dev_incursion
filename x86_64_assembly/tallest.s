.section .text
.globl _start
_start:
	leaq people, %rbx
	movq num_people, %rcx

	movq $0, %rdi
	cmpq $0, %rcx
	je finish
main_loop:
	movq HEIGHT_OFFSET(%rbx), %rax
	cmpq %rdi, %rax
	jbe end_loop
	movq %rax, %rdi
end_loop:
	addq $PERSON_RECORD_SIZE, %rbx
	loopq main_loop
finish:
	movq $60, %rax
	syscall
