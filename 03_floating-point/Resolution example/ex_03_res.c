#include <stdio.h>
#include <stdlib.h>
#include <float.h>
#include <math.h>

void main(void)
{
    system("cls");
    float a;

    printf("\nNAN = %e", NAN);

    printf("\nINFINITY = %e", INFINITY);

    printf("\n-INFINITY = %e", -INFINITY);

    // a = 0/0; // fails because integers do not define nan or inf
    a = 0./0;
    printf("\n\n0./0 = %e", a);

    // a = 23/0; // fails because integers do not define nan or inf
    a = 23./0;
    printf("\n\n23./0 = %e", a);    

    // a = -23/0; // fails because integers do not define nan or inf
    a = -(23./0);
    printf("\n\n-23./0 = %e ", a);  

    printf("\n");
}