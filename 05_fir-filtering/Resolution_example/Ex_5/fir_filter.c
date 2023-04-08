
#include "fir_filter.h"
#include "fdacoefs.h"
#include "mex.h"

// #define DEBUG


typedef short int16_t;
typedef int int32_t;


// 
// void fir_online_float(float *input, float *output)
// {
//     static uint32_t counter = 0;
//     static float cir_buff[101] = {0.0};
//     static float * start = &cir_buff[0];   // pointer to the start of the circular buffer
//     static float * end = &cir_buff[BL-1];  // pointer to the end of the circular buffer
//     static float * head;                    // pointer to the new element at the circular buffer
//     
//     uint32_t j, idx;
//     float acc;
//     
// #ifdef  DEBUG
//     mexPrintf("input = %f \n", *(input) );
// #endif
//     
// #ifdef  DEBUG
//     mexPrintf("output = %f \n", *(input) );
// #endif
//     
//     idx = counter % BL;             // modulus operator
//     counter++;
// 
//     cir_buff[idx] = *(input);       // load new element to the circular buffer
//     head = &cir_buff[idx];          // pointer new element at the circular buffer
//     
//     acc = 0.0;
//     
//     for (j = 0; j < BL; j++)
//     {
//         acc = acc + ( *(head--) * B[j] );
//         
//         if(head < start){
//             head = end;
//         }        
//     }
//     
// #ifdef  DEBUG
//     mexPrintf("acc = %f \n", acc);
// #endif
//     
//     *(output) = acc;
// }
// 
// 
// void fir_offline_float(float *input, uint32_t N, float *output)
// {
// 	uint32_t i, j;
// 
//     float acc;
// 
// 	for (i=0; i < N; i++)
// 	{
// 		output[i] = 0.0;
// 	}
// 
// 	for (i=0; i < N-BL; i++)
// 	{
// 		acc = 0.0;
// 
// 		for (j=0; j < BL; j++)
// 		{
// 			acc = acc + (input[j+i] * B[j]);
// 		}
// 
// 		output[i+BL] = acc;
// 	}
// }

// void fir_online_fixed(float *input, uint32_t N, float *output)
// {
// 	uint32_t i;
// 
// 	for (i=0; i < N; i++)
// 	{
// 		output[i] = input[i];
// 	}
// 
// }


int32_t truncation(int32_t x, int n) // only for multiplication
{
    return x >> n; // result of multiplication has double of fraction bits
}



void fir_online_fixed(int16_t *input, int16_t *output, int frac_bits)
{
    static uint32_t counter = 0;
//     static float cir_buff[101] = {0.0};
//     static float * start = &cir_buff[0];   // pointer to the start of the circular buffer
//     static float * end = &cir_buff[BL-1];  // pointer to the end of the circular buffer
//     static float * head;                    // pointer to the new element at the circular buffer

    static int32_t cir_buff[101] = {0.0};
    static int32_t * start = &cir_buff[0];   // pointer to the start of the circular buffer
    static int32_t * end = &cir_buff[BL-1];  // pointer to the end of the circular buffer
    static int32_t * head;                    // pointer to the new element at the circular buffer
    
    uint32_t j, idx;
    
//     float acc;
    int32_t acc;
    
    
#ifdef  DEBUG
    mexPrintf("input = %f \n", *(input) );
#endif
    
#ifdef  DEBUG
    mexPrintf("output = %f \n", *(input) );
#endif
    
    idx = counter % BL;             // modulus operator
    counter++;

    cir_buff[idx] = *(input);       // load new element to the circular buffer
    head = &cir_buff[idx];          // pointer new element at the circular buffer
    
//     acc = 0.0;
    acc = 0;
    
    for (j = 0; j < BL; j++)
    {
        acc = acc + truncation( *(head--) * B[j] , frac_bits);
        
        if(head < start){
            head = end;
        }        
    }
    
#ifdef  DEBUG
    mexPrintf("acc = %f \n", acc);
#endif
    
    *(output) = acc;
}
