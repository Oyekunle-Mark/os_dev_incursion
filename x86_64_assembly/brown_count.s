.section .text
.globl _start
_start:
	leaq people, %rbx
	movq num_people, %rcx
	movq $0, %rdi

	cmpq $0, %rcx
	je finish
main_loop:
	# brown hair is denoted by 2
	# compare hair field with 2
	cmpq $2, HAIR_OFFSET(%rbx)
	# if not brown
	jne end_loop
	# otherwise, increment count in %rdi
	incq %rdi
end_loop:
	# move %rbx to next person record
	addq $PERSON_RECORD_SIZE, %rbx
	loopq main_loop
finish:
	movq $60, %rax
	syscall
