.section .data
my_text:
	.string "Hello there, my good fellow.\n"

.section .text
.globl print_stuff
.type print_stuff, @function
print_stuff:
	# we still require calling enter and leave when calling other
	# functions even if we do not use the stack
	# we do this to ensure the stack is properly set up
	enter $0, $0

	# pc-relative addressing of stdout(a shared data)
	movq stdout@GOTPCREL(%rip), %rdi
	movq (%rdi), %rdi
	# load the address of my_text as pc_relative
	leaq my_text(%rip), %rsi
	# the shared function fprintf is called using PIC(position
	# independent code) here by referencing the PLT(procedure
	# linkage table)
	call fprintf@plt
	
	leave
	ret
