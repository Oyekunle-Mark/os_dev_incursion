.section .data
my_test:
	# the .ascii directive is used to declare textual text
	.ascii "This is a string of characters.\0"

.section .text
.globl _start
_start:
	# mov address of my_test(notice the '$' at the start)
	# into the base register
	movq $my_test, %rbx
	# starting count with zero
	movq $0, %rdi
main_loop:
	# move byte into the lower byte part of %rax
	movb (%rbx), %al

	# compare current byte with null character(0)
	# null denotes the end of the string
	cmpb $0, %al
	# end loop if we are at the end
	je finish

	# we compare current byte with character code of 'a'
	cmpb $'a', %al
	# can't be lower case if lower
	jb loop_control

	# compare current character with character code of 'z'
	cmpb $'z', %al
	# cannot be lowercase if above
	ja loop_control

	# we have a lower case character, increment count
	incq %rdi
loop_control:
	# move rbx to the next byte
	incq %rbx
	# return to counting
	jmp main_loop
finish:
	movq $60, %rax
	syscall
