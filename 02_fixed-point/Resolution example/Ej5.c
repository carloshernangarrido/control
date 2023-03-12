#include <math.h>
#include <stdio.h>
#include <stdint.h>

double X[5] = {1.1, 2.2, 3.3, 4.4, 5.5 };
double Y[5] = {6.6, 7.7, 8.8, 9.9, 10.10};
double Z;

void main(void)
{
    // Multiply and ACumulate (MAC) as double float
    Z = 0;
    for(int i = 0; i < sizeof(X) / sizeof(X[0]); i++)
    {
        Z = Z + X[i] * Y[i];
        printf("%f ", Z);
    }
    printf("\nFinal result: %f", Z);

    
}
