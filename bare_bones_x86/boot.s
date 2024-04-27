/*
An OS image must contain an additional header called Multiboot header, besides the headers of the format used by the OS image.
The Multiboot header must be contained completely within the first 8192 bytes of the OS image, and must be longword (32-bit) aligned.
In general, it should come as early as possible, and may be embedded in the beginning of the text segment after the real executable header.
*/
.set MULTIBOOT_MAGIC, 		0x1BADB002 // The field ‘magic’ is the magic number identifying the header, which must be the hexadecimal value 0x1BADB002.
.set MULTIBOOT_ALIGN, 		1 << 0
.set MULTIBOOT_MEMINFO, 	1 << 1
.set MULTIBOOT_FLAGS,		MULTIBOOT_ALIGN | MULTIBOOT_MEMINFO // The field ‘flags’ specifies features that the OS image requests or requires of an boot loader
.set MULTIBOOT_CHECKSUM,	(0 -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)) // The field ‘checksum’ is a 32-bit unsigned value which, when added to the other magic fields (i.e. ‘magic’ and ‘flags’), must have a 32-bit unsigned sum of zero.

// section for the magic fields of Multiboot header
.section .multiboot
.align 4
.long MULTIBOOT_MAGIC
.long MULTIBOOT_FLAGS
.long MULTIBOOT_CHECKSUM

.section .bss
.align 16 // x86 required a 16-bytes aligned stack
stack_bottom:
	.skip 4096 // reserve 4kb for the stack
stack_top:

.section .text
.global start
// starting point of our kernel
start:
	/*
	We must first setup the stack. To do that, we set a value for *%esp* register, the stack pointer
	On x86, the stack grows downward.
	*/
	mov $stack_top, %esp

	// call the *kernel_main* function we will write later in *kernel.c*.
	call kernel_main

// we shouldn't return from *kernel_main*, if we do, we will hang up the CPU
loop:
	cli // disables CPU interrupts
	hlt // halt
	jmp loop // if we do end up here, loop back
