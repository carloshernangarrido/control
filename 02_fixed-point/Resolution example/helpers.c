#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>


#define MAX_BINARY_LENGTH 65  // Longitud máxima de la cadena de salida (64 bits + '\0')

// Función para convertir un carácter hexadecimal en un entero (0-15)
int hex_char_to_int(char c) {
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    } else {
        return -1;  // Carácter no válido
    }
}

// Función para convertir una cadena de hexadecimales en una cadena de bits
void hex_to_binary(char* hex_string, char* binary_string) {
    size_t hex_len = 0;
    while (hex_string[hex_len] != '\0') {
        hex_len++;
    }
    binary_string[0] = '\0';  // Inicializar la cadena de salida con una cadena vacía
    int binary_index = 0;
    for (size_t i = 0; i < hex_len; i++) {
        int hex_digit = hex_char_to_int(hex_string[i]);
        if (hex_digit == -1) {
            fprintf(stderr, "Error: carácter no válido '%c'.\n", hex_string[i]);
            exit(EXIT_FAILURE);
        }
        for (int j = 3; j >= 0; j--) {  // Convertir el dígito hexadecimal en una cadena binaria de 4 bits
            binary_string[binary_index] = (hex_digit & (1 << j)) ? '1' : '0';
            binary_index++;
        }
    }
    binary_string[binary_index] = '\0';  // Agregar el carácter nulo al final de la cadena
}



// Función para convertir un entero en una cadena de bits
void pad_with_zeros(char* str) {
    int len = strlen(str);
    if (len >= 64) {
        return; // la cadena ya es de 64 caracteres o más
    }
    int num_zeros = 64 - len;
    char zeros[65] = ""; // arreglo para almacenar los ceros
    for (int i = 0; i < num_zeros; i++) {
        strcat(zeros, "0"); // concatenar ceros al arreglo
    }
    strcat(zeros, str); // concatenar la cadena original al arreglo de ceros
    strcpy(str, zeros); // copiar la cadena con ceros de vuelta a la cadena original
}


void insert_dot(char* str, int pos) {
    int len = strlen(str);
    if (pos >= len || pos < 0) {
        return; // la posición está fuera del rango válido de la cadena
    }
    char tmp[len+2];
    strncpy(tmp, str, pos); // copiar los caracteres a la izquierda de la posición
    tmp[pos] = '.'; // insertar el punto en la posición deseada
    strncpy(tmp+pos+1, str+pos, len-pos); // copiar los caracteres a la derecha de la posición
    strncpy(str, tmp, len+1); // copiar el resultado de vuelta a la cadena original
}

char x_fx_char_hex[17];
void int2binary(int64_t x, char* binary_string, int fraction_bits)
{
    int dot_pos = 64 - fraction_bits;
    sprintf(x_fx_char_hex, "%X", x);
    hex_to_binary(x_fx_char_hex, binary_string);
    pad_with_zeros(binary_string);
    insert_dot(binary_string, dot_pos);
}
    