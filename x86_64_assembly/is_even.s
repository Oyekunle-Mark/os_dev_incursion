# find if a number(in %rax) is even or odd
# exits with 1 if event, 0 if odd
.section .text
.globl _start
_start:
	# start with number in %rax
	movq $34357, %rax
	# move divisor(divide by 2 to find if even) to %rsi
	# divq only accepts a source that is a register or memory location
	movq $2, %rsi
	# divide
	divq %rsi

	# is the remainder 0?
	cmpq $0, %rdx
	# jump to even label to set exit code
	je even

	# number is odd, set exit code
	movq $0, %rdi
	# jump to exit label to issue exit syscall
	jmp exit
even:
	movq $1, %rdi 
exit:
	movq $60, %rax
	syscall
