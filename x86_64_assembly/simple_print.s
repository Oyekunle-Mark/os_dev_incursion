# this program prints a string to standard output
.section .data
# the string to be printed
my_string:
	.ascii "Hello world!\n"
end_of_my_string: # simple denotes end of string for calculation purposes

# find string lenght(in number of bytes) by subtracting end from start
.equ MY_STRING_LENGTH, end_of_my_string - my_string

.section .text
.globl _start
_start:
	# the write syscall is number 1
	movq $1, %rax
	# first argument to write is file descriptor to write to
	# we write to standard output(1)
	movq $1, %rdi
	# second argument to write is the address of the string to be
	# written
	movq $my_string, %rsi
	# third argument is number of bytes to be written
	movq $MY_STRING_LENGTH, %rdx
	syscall

	# issue the exit syscall
	movq $0x3c, %rax
	movq $0, %rdi
	syscall
