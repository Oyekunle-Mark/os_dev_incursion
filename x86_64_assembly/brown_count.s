.section .text
.globl _start
_start:
	leaq people, %rbx
	movq num_people, %rcx

	movq $0, %rdi

	cmpq $0, %rcx
	je finish
main_loop:
	cmpq $2, HAIR_OFFSET(%rbx)
	jne end_loop
	incq %rdi
end_loop:
	addq $PERSON_RECORD_SIZE, %rbx
	loopq main_loop
finish:
	movq $60, %rax
	syscall
