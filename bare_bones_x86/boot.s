.set MULTIBOOT_MAGIC, 		0x1BADB002
.set MULTIBOOT_ALIGN, 		1 << 0
.set MULTIBOOT_MEMINFO, 	1 << 1
.set MULTIBOOT_FLAGS,		MULTIBOOT_ALIGN | MULTIBOOT_MEMINFO
.set MULTIBOOT_CHECKSUM,	(0 -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)) 

.section .multiboot
.align 4
.long MULTIBOOT_MAGIC
.long MULTIBOOT_FLAGS
.long MULTIBOOT_CHECKSUM

.section .bss
.align 16
stack_bottom:
	.skip 4096
stack_top:

.section .text
.global start
start:
	mov $stack_top, %esp

	call kernel_main

loop:
	cli
	hlt
	jmp loop

