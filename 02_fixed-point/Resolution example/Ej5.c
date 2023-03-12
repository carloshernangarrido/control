#include <math.h>
#include <stdio.h>
#include <stdint.h>

#include "helpers.c"


#define FRACTION_BITS 10 // Q21.10


int32_t fp2fx(double x, int n)
{
    return round(x * (1 << n));
}

double fx2fp(int32_t x, int n)
{
    return (double)x / (1 << n);
}
int32_t truncation(int64_t x, int n) // only for multiplication
{
    return x >> n; // result of multiplication has double of fraction bits
}
int32_t rounding(int64_t x, int n) // only for multiplication
{
    return truncation(x + (1 << (n - 1)), n);
}


double X[5] = {1.1, 2.2, 3.3, 4.4, 5.5 };
double Y[5] = {6.6, 7.7, 8.8, 9.9, 10.10};
double Z;

int32_t A[5], B[5], acum_32;
int64_t acum_64;

// for printf representation
char acum32_char_bin[65], acum64_char_bin[65];


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

    // Conversion to Fixed Point
	for(int i = 0; i < sizeof(X) / sizeof(X[0]); i++)
	{
        A[i] = fp2fx(X[i], FRACTION_BITS);
        B[i] = fp2fx(Y[i], FRACTION_BITS);
	}


    // Multiply using Fixed Point acum_32
	for(int i = 0; i < sizeof(X) / sizeof(X[0]); i++)
	{
        acum_32 += (int32_t) truncation(A[i] * B[i], FRACTION_BITS);
        int2binary(acum_32, acum32_char_bin, FRACTION_BITS);
        printf("\nacum_32 = %s = %.30f", acum32_char_bin, fx2fp(acum_32, FRACTION_BITS));
	}
    printf("\n");
    // Multiply using Fixed Point acum_64
	for(int i = 0; i < sizeof(X) / sizeof(X[0]); i++)
	{
        acum_64 += (int64_t) ( (int64_t) A[i] * (int64_t) B[i] );

        int2binary(acum_64, acum64_char_bin, 2*FRACTION_BITS);

        // truncates to 32 bit before converting to float, so it does not represents the actually stored FX value
        // printf("\nacum_64 = %s = %.20f", acum64_char_bin, fx2fp(truncation(acum_64, FRACTION_BITS), FRACTION_BITS));

        printf("\nacum_64 = %s = %.30f", acum64_char_bin, fx2fp(acum_64, 2*FRACTION_BITS));

	}

}
