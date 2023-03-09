// Cree 2 funciones:
// 1.	Una función para pasar de punto fijo a punto flotante, fx2fp( ).
// 2.	Una función para pasar de punto flotante a punto fijo, fp2fx( ).
// 3.	Verifique el correcto funcionamiento para Q23.8 haciendo
// b = fx2fp( fp2fx( 2.4515) )
// 4.	Compare b con 2.4515 para Q23.8 y Q21.10

#include <math.h>
#include <stdio.h>
#include <stdint.h>

#include "helpers.c"

#define FRACTION_BITS 8


int32_t fp2fx(float x, int n)
{
    return round(x * (1 << n));
}

int32_t fp2fx_trunc(float x, int n)
{
    return (x * (1 << n));
}

float fx2fp(int32_t x, int n)
{
    return (float)x / (1 << n);
}


void main(void)
{
    float x_float, x_float_;
    int32_t x_fx_int32_t;
    char x_fx_char_hex[17];
    char x_fx_char_bin[65];

    x_float = 2.4515;

    printf("\n**********\nUsing round");

    x_fx_int32_t = fp2fx(x_float, FRACTION_BITS);

    x_float_ = fx2fp(x_fx_int32_t, FRACTION_BITS);

    sprintf(x_fx_char_hex, "%X", x_fx_int32_t);
    hex_to_binary(x_fx_char_hex, x_fx_char_bin);

    printf("\nOriginal float number: %f", x_float);
    printf("\nNumber in fixed point with notation Q%d.%d in hex: %s", 31-FRACTION_BITS, FRACTION_BITS, x_fx_char_hex);
    printf("\nNumber in fixed point with notation Q%d.%d in bin: %s", 31-FRACTION_BITS, FRACTION_BITS, x_fx_char_bin);
    printf("\nRecovered float number: %f", x_float_);

    printf("\n\nWithout using round");

    x_fx_int32_t = fp2fx_trunc(x_float, FRACTION_BITS);

    x_float_ = fx2fp(x_fx_int32_t, FRACTION_BITS);

    sprintf(x_fx_char_hex, "%X", x_fx_int32_t);
    hex_to_binary(x_fx_char_hex, x_fx_char_bin);

    printf("\nOriginal float number: %f", x_float);
    printf("\nNumber in fixed point with notation Q%d.%d in hex: %s", 31-FRACTION_BITS, FRACTION_BITS, x_fx_char_hex);
    printf("\nNumber in fixed point with notation Q%d.%d in bin: %s", 31-FRACTION_BITS, FRACTION_BITS, x_fx_char_bin);
    printf("\nRecovered float number: %f", x_float_);
}