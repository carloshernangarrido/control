#include <math.h>
#include <stdio.h>
#include <stdint.h>

#include "helpers.c"

#define FRACTION_BITS 3

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
int32_t saturation(int64_t x) // for opperations that preserve presicion
{
    if (x > INT32_MAX)
    {
        return INT32_MAX;
    }
    else if (x < INT32_MIN)
    {
        return INT32_MIN;
    }
    else
    {
        return x;
    }
}

void main(void)
{
    double x_float, y_float, z_float, z_float_, z_float_rounding, z_float_saturation;
    int32_t x_fx_int32_t, y_fx_int32_t, z_fx_int32_t, z_fx_int32_t_rounding, z_fx_int32_t_saturation;
    int64_t z_fx_int64_t;

    char x_fx_char_hex[17], y_fx_char_hex[17], z_fx_char_hex[17], z_fx64_char_hex[17];
    char x_fx_char_bin[65], y_fx_char_bin[65], z_fx_char_bin[65], z_fx_char_bin_rounding[65], z_fx64_char_bin[65];

    // Multiplication using the FPU
    x_float = (double)1 / 2;
    y_float = -3. / 8;
    z_float = x_float * y_float;

    // Conversion to fixed point
    x_fx_int32_t = fp2fx(x_float, FRACTION_BITS);
    sprintf(x_fx_char_hex, "%X", x_fx_int32_t);
    hex_to_binary(x_fx_char_hex, x_fx_char_bin);
    y_fx_int32_t = fp2fx(y_float, FRACTION_BITS);
    sprintf(y_fx_char_hex, "%X", y_fx_int32_t);
    hex_to_binary(y_fx_char_hex, y_fx_char_bin);

    // Multiplication in fixed point, result has double of FRACTION_BITS
    z_fx_int64_t = x_fx_int32_t * y_fx_int32_t;
    sprintf(z_fx64_char_hex, "%X", z_fx_int64_t);
    hex_to_binary(z_fx64_char_hex, z_fx64_char_bin);

    // Truncation to store an int32_t
    z_fx_int32_t = truncation(z_fx_int64_t, FRACTION_BITS);
    sprintf(z_fx_char_hex, "%X", z_fx_int32_t);
    hex_to_binary(z_fx_char_hex, z_fx_char_bin);
    // Recovering of float
    z_float_ = fx2fp(z_fx_int32_t, FRACTION_BITS);

    // Rounding to store an int32_t
    z_fx_int32_t_rounding = rounding(z_fx_int64_t, FRACTION_BITS);
    sprintf(z_fx_char_hex, "%X", z_fx_int32_t_rounding);
    hex_to_binary(z_fx_char_hex, z_fx_char_bin_rounding);
    // Recovering of float
    z_float_rounding = fx2fp(z_fx_int32_t_rounding, FRACTION_BITS);

    printf("\n**** Ej. 3 ******\n");
    printf("\nUsing the FPU: %f x %f = %f", x_float, y_float, z_float);
    printf("\n%f in Q%d.%d is: %s", x_float, 31 - FRACTION_BITS, FRACTION_BITS, x_fx_char_bin);
    printf("\n%f in Q%d.%d is: %s", y_float, 31 - FRACTION_BITS, FRACTION_BITS, y_fx_char_bin);
    printf("\nUsing Fixed Point with Truncation: \n%s x %s = %s = %s = %f",
           x_fx_char_bin, y_fx_char_bin, z_fx64_char_bin, z_fx_char_bin, z_float_);
    printf("\nUsing Fixed Point with Rounding: \n%s x %s = %s = %s = %f",
           x_fx_char_bin, y_fx_char_bin, z_fx64_char_bin, z_fx_char_bin_rounding, z_float_rounding);

    // Test of truncation
    x_float = INT32_MAX / (1 << (FRACTION_BITS)); //pow(2, 32-FRACTION_BITS-1) - 1;
    printf("\nUsing the FPU:                                          Using Fixed point without saturation            Using Fixed point with saturation");
    for (y_float = -10.; y_float < 10; y_float += 1.)
    {
        //////////////////////////////////// Using the FPU
        z_float = x_float + y_float;

        //////////////////////////////////// Using Fixed Point
        // Conversion to fixed point
        x_fx_int32_t = fp2fx(x_float, FRACTION_BITS);
        y_fx_int32_t = fp2fx(y_float, FRACTION_BITS);
        // Operation in Fixed Point
        z_fx_int64_t = (int64_t)x_fx_int32_t + (int64_t)y_fx_int32_t;
        // Store an int32_t
        z_fx_int32_t = z_fx_int64_t;
        z_fx_int32_t_saturation = saturation(z_fx_int64_t);
        // Recovering of float
        z_float_ = fx2fp(z_fx_int32_t, FRACTION_BITS);
        z_float_saturation = fx2fp(z_fx_int32_t_saturation, FRACTION_BITS);
        printf("\n%f + %f = %f             %f                                 %f", x_float, y_float, z_float, z_float_, z_float_saturation);
    }
}
