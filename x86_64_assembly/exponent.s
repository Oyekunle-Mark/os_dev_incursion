# this function finds the exponent of a number
# the first parameter is the base, the second the exponent

.globl exponent
.type exponent, @function

.section .text
exponent:
	# base is in %rdi
	# exponent is in %rsi

	# issue enter to create a new stack frame
	# enter $16, $0 is equivalent to:
	# 1. pushq %rbp
	# 2. movq %rsp, %rbp
	# 3, subq $16, %rsp
	# even though we only need a single quadword value on the
	# stack, we are allocating 16 types because the System v ABI
	# requires the stack to be 16 byte stack aligned.
	enter $16, $0
	# set the accumulator to 1
	movq $1, %rax
	# move the exponent into the stack
	# %rbp is used for referencing the stack
	movq %rsi, -8(%rbp)
main_loop:
	# multiply the base by %rax
	mulq %rdi
	# decrement the exponent
	decq -8(%rbp)
	# jump to repeat multiplication if expoent is
	# greater than zero
	jnz main_loop
complete:
	# the return value is alread in %rax

	# issue leave to destroy the stack frame
	# leave is equivalent to:
	# 1. movq %rbp, %rsp
	# 2. popq %rbp
	leave
	# ret returns from the function
	# ret is equivalent to:
	# 1. popq %rip(pops the return address from the stop of the stack)
	# 2. jmp <to address popped in 1 above>
	ret
