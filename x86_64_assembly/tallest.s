.section .text

.globl _start
_start:
	# move the address of people to the base register
	leaq people, %rbx
	movq num_people, %rcx

	# the starting value of the tallest person
	movq $0, %rdi
	# check if there are zero people and terminate early
	cmpq $0, %rcx
	je finish
main_loop:
	# access the height using the HEIGHT_OFFSET label
	# this line moves the height into %rax
	movq HEIGHT_OFFSET(%rbx), %rax
	# compare this to current height
	cmpq %rdi, %rax
	# if it is below current, jump to end_loop
	jbe end_loop
	# otherwise, set it as new highest
	movq %rax, %rdi
end_loop:
	# move base register forward to next person struct
	addq $PERSON_RECORD_SIZE, %rbx
	# decrement %rcx and jump to main_loop if %rcx is > 0
	loopq main_loop
finish:
	movq $60, %rax
	syscall
