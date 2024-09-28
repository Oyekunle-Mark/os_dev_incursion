# This program does very little
# It only calls the exit system call

# the .globl directive tells the assembly not to discard the _start
# symbol after assembling the file
.globl _start
# the next .section directive tells the assembly to place the next
## should be placed in the code section of the program
.section .text
# the linker uses the _start symbol as where the program execution
# begins from. i.e. the "entry point"
_start:
	movq $60, %rax # the exit system call is number 60, move it into rax
	movq $3, %rdi # the first argument to exit, that is the exit code to be returned
	syscall

# assemble with => as -o my_exit.o my_exit.s
# link with => ld -o my_exit my_exit.o
