#include <stddef.h>
#include <stdint.h>

/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
	#error "This program is not being compiled with a cross-compiler"
#endif
 
/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
	#error "This program is meant to target ix86"
#endif

// VGA text mode console is 80 columns by 25 rows
const size_t VGA_ROWS = 25;
const size_t VGA_COLS = 80;

// The VGA text buffer is located at physical memory address 0xB8000
uint16_t* vga_buffer = (uint16_t*)0xB8000;

size_t row_index = 0;
size_t col_index = 0;

// uint8_t VGA_COLOR_BLACK = 0;
// uint8_t VGA_COLOR_WHITE = 15;
// we are shifting the backgroud color left by 4 and bit ORing with the foregroud color
uint8_t terminal_color = 0 << 4 | 15;

/**
 * terminal_initialize clears the entire screen
 * by writing blank, the space character
 */
void terminal_initialize()
{
	for(size_t col = 0; col < VGA_COLS; col++)
	{
		for(size_t row = 0; row < VGA_ROWS; row++)
		{
			const size_t index = (VGA_COLS * row) + col;
			// shift terminal color to it's place and set the character code point to blank
			vga_buffer[index] = ((uint16_t)terminal_color << 8) | ' ';
		}
	}
}

/**
 * terminal_write_char writes a single character to the terminal.
 * Accounts for newlines
 */
void terminal_write_char(char c)
{
	switch(c)
	{
		case '\n':
		{
			col_index = 0;
			row_index++;
			break;
		}
		default:
		{
			const size_t index = (VGA_COLS * row_index) + col_index;
			vga_buffer[index] = ((uint16_t)terminal_color << 8) | c;
			col_index++;
			break;
		}
	}

	if (col_index == VGA_COLS)
	{
		col_index = 0;
		row_index++; 
	}

	if (row_index == VGA_ROWS)
	{
		row_index = 0;
		col_index = 0; 
	}
}

/**
 * terminal_write_string writes each character in the
 * string to the terminal.
 */
void terminal_write_string(const char* str)
{
	for(size_t i = 0; str[i] != '\0'; i++)
		terminal_write_char(str[i]);
}

void kernel_main()
{
	terminal_initialize();

	terminal_write_string("Hello, world!\n");
	terminal_write_string("This is my first kernel. :)\n");
}
