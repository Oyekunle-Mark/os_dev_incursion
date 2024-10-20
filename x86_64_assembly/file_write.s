.section .data
filename:
	# strings passed to the C standard library functions
	# are expected to be null terminated
	.ascii "my_file.txt\0"
open_mode:
	.ascii "w\0"
format_string1:
	.ascii "The age of %s is %d.\n\0"
sally_name:
	.ascii "Sally\0"
sally_age:
	.quad 53
format_string2:
	.ascii "%d and %d are %s's favourite numbers.\n\0"
josh_name:
	.ascii "Josh\0"
josh_fav_first:
	.quad 7
josh_fav_second:
	.quad 13

.section .text
.globl main
# we are using the C runtime library entry point of main
# instead of _start because we are linking the C standard
# library into this program
main:
	# create a 16 bytes aligned stack frame
	enter $16, $0

	# calling fopen
	# move the pointer to the filename to %rdi
	movq $filename, %rdi
	# move the pointer to the open mode string to %rsi
	movq $open_mode, %rsi
	# call fopen
	call fopen

	# move the FILE* to the stack
	movq %rax, -8(%rbp)

	# calling fprintf
	# move FILE* to %rdi
	movq -8(%rbp), %rdi
	# move pointer to format string to %rsi
	movq $format_string1, %rsi
	# move pointer to rest of variadic argument to the registers
	movq $sally_name, %rdx
	movq sally_age, %rcx
	# we set %rax to 0 because a C standard library that accepts a
	# variadic argument must expects %rax to be set to zero when one 
	# of the argument is not a floating point number
	movq $0, %rax
	# call fprintf
	call fprintf

	# another fprintf call
	movq -8(%rbp), %rdi
	movq $format_string2, %rsi
	movq josh_fav_first, %rdx
	movq josh_fav_second, %rcx
	movq $josh_name, %r8
	movq $0, %rax
	call fprintf

	# calling fclose
	# move FILE* to %rdi
	movq -8(%rbp), %rdi
	# call fclose
	call fclose


	# set return value to 0
	movq $0, %rax
	# delete the stack frame and return
	leave
	ret
	# we do not have to call the exit syscall ourself.
	# because we are using gcc for compiling the C runtime library
	# creates _start and calls exit for us.
