.section .data
my_text:
	.string "Hello there, my good fellow.\n"

.section .text
.globl print_stuff
.type print_stuff, @function
print_stuff:
	enter $0, $0

	movq stdout@GOTPCREL(%rip), %rdi
	movq (%rdi), %rdi
	leaq my_text(%rip), %rsi
	call fprintf@plt
	
	leave
	ret
