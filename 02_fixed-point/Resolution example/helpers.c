#include <stdio.h>
#include <stdlib.h>

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
