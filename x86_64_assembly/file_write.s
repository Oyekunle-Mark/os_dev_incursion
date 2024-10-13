.section .data
filename:
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
main:
	enter $16, $0

	movq $filename, %rdi
	movq $open_mode, %rsi
	call fopen

	movq %rax, -8(%rbp)

	movq -8(%rbp), %rdi
	movq $format_string1, %rsi
	movq $sally_name, %rdx
	movq sally_age, %rcx
	movq $0, %rax
	call fprintf

	movq -8(%rbp), %rdi
	movq $format_string2, %rsi
	movq josh_fav_first, %rdx
	movq josh_fav_second, %rcx
	movq $josh_name, %r8
	movq $0, %rax
	call fprintf

	movq -8(%rbp), %rdi
	call fclose


	movq $0, %rax
	leave
	ret
