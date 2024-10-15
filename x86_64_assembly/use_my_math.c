#include<stdio.h>

long square_me(long);
long mult_by_ten(long);
void print_stuff();

int main() {
	long number = 4;
	fprintf(stdout, "The square of %d is %d\n", number, square_me(number));
	fprintf(stdout, "Ten times %d is %d\n", number, mult_by_ten(number));
	print_stuff();

	return 0;
}
