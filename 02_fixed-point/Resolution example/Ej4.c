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

// Ej. 3
int32_t truncation(int64_t x, int n) // only for multiplication
{
    return x >> n; // result of multiplication has double of fraction bits
}
int32_t rounding(int64_t x, int n) // only for multiplication
{
    return truncation(x + (1 << (n - 1)), n);
}
// int32_t saturation(int64_t x) // for opperations that preserve presicion
// {
//     if (x > INT32_MAX)
//     {
//         return INT32_MAX;
//     }
//     else if (x < INT32_MIN)
//     {
//         return INT32_MIN;
//     }
//     else
//     {
//         return x;
//     }
// }

void main(void)
{
    double x_float, y_float, z_float, z_float_, z_float_rounding;
    int32_t x_fx_int32_t, y_fx_int32_t, z_fx_int32_t, z_fx_int32_t_rounding;
    int64_t z_fx_int64_t;
    
    x_float = 62.4;
    y_float = 41.2;

    z_float = x_float * y_float;


    x_fx_int32_t = fp2fx(x_float, FRACTION_BITS);
    y_fx_int32_t = fp2fx(y_float, FRACTION_BITS);

    // // does not work!
    // z_fx_int64_t = x_fx_int32_t * y_fx_int32_t;

    z_fx_int64_t = (int64_t)x_fx_int32_t * (int64_t)y_fx_int32_t;
    z_fx_int32_t = truncation(z_fx_int64_t, FRACTION_BITS);
    z_fx_int32_t_rounding = rounding(z_fx_int64_t, FRACTION_BITS);

    z_float_ = fx2fp(z_fx_int32_t, FRACTION_BITS);
    z_float_rounding = fx2fp(z_fx_int32_t_rounding, FRACTION_BITS);

    printf("\nUsing the FPU:\n%f x %f = %f", x_float, y_float, z_float);
    printf("\nUsing Fixed Point with truncation:\n%f x %f = %f", x_float, y_float, z_float_);
    printf("\nUsing Fixed Point with rounding:\n%f x %f = %f", x_float, y_float, z_float_rounding);   
}