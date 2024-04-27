/* Our designated starting point. The symbol created in *boot.s*. The bootloader will begin execution here*/
ENTRY(start)

SECTIONS
{
	/* start placing sections at 1 MB */
	. = 1M;

	/* all sections are 4 kb aligned to accomodate paging later on */
	/* place multiboot header first followed by read only data */
	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.multiboot)
		*(.rodata)
	}

	/* executable code */
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.text)
	}

	/* initialized data */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}

	/* uninitialzed data and stack */
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}
}
