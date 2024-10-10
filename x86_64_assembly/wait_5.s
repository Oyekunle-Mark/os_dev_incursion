# this program gets the current time from the kernel
# and keeps pulling the current time until 5 seconds
# has passed since the first time it got.
.section .data
# the address that would be passed to the time syscall
# parameter is a 64-bit memory address
current_time:
	.quad 0
.section .text
.globl _start
_start:
	# time syscall number is 201(0xc9)
	movq $0xc9, %rax
	# move address of current_time to %rdi
	movq $current_time, %rdi
	syscall

	# copy current_time time over to %rdx
	movq current_time, %rdx
	# add 5 seconds to it
	addq $5, %rdx
time_loop:
	# in this loop we repeatedly get the current time
	# check if it is past the time in %rdx
	# if it is not, we continue polling time(waiting...)
	movq $0xc9, %rax
	movq $current_time, %rdi
	syscall

	cmpq %rdx, current_time
	jb time_loop
finish:
	movq $0x3c, %rax
	movq $0, %rdi
	syscall

