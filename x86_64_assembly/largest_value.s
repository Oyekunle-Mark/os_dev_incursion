# this program finds the largest value in an array stored in memory
# declare fixed lenght data section
.section .data
# variables are created as labels
# number_of_numbers is the size of the array numbers
number_of_numbers:
	# the .quad directive is to declare a 64-bit number or an array of 64-bit numbers
	.quad 7
numbers:
	.quad 5, 20, 33, 80, 52, 10, 1

.section .text
.globl _start
_start:
	movq number_of_numbers, %rcx
	# we start with 0 as the current max
	movq $0, %rdi

	# if we have processed all the items in the array, we should jump to endloop
	cmp $0, %rcx
	je endloop
myloop:
	# we use the general addressing mode syntax i.e. value(base,index,multiplier)
	# to iterate through the array
	# from the last element to the first(reverse order)
	# the numbers-8 is to prevent an off by 1 because %rcx starts at number_of_numbers
	movq numbers-8(,%rcx,8), %rax
	# compare %rax to the current max
	cmp %rdi, %rax
	# if lower jump to loopcontrol
	jbe loopcontrol

	# otherwise(higher), replace %rdi with new max
	movq %rax, %rdi
loopcontrol:
	# decrements %rcx by 1 and jump to myloop if %rcx is greater than zero
	loopq myloop
endloop:
	movq $60, %rax
	syscall
