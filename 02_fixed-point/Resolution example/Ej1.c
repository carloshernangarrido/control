#include <math.h>
#include <stdio.h>
#include <stdint.h>

void main(void)
{	
	// signed char a, b, c, d, s1, s2;
    unsigned char a, b, c;
    int32_t d; 
    signed char s1, s2;

	
	a = 127;
	b = 127;
	
	c = a + b;	
	// d = a * b;
	d = (a * b);
	
	s1 = (-8) >> 2;
	s2 = (-1) >> 5;

	printf("c = %d \n", c );
	printf("d = %d \n", d );
	printf("s1 = %d \n", s1 );
	printf("s2 = %d \n", s2 );
}
