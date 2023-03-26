// Version: 002
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>
#include <fenv.h>


// Compile usando el siguiente comando
// compile: gcc -Wall -O3 -std=c99 ex_04_res.c -o ex_04_res -lm -march=corei7 -frounding-math -fsignaling-nans

#define _GNU_SOURCE 1
#define _ISOC99_SOURCE
#include <fenv.h>

void show_fe_exceptions(void)
{
    printf("current exceptions raised: ");
    if(fetestexcept(FE_DIVBYZERO))     printf(" FE_DIVBYZERO");
    if(fetestexcept(FE_INEXACT))       printf(" FE_INEXACT");
    if(fetestexcept(FE_INVALID))       printf(" FE_INVALID");
    if(fetestexcept(FE_OVERFLOW))      printf(" FE_OVERFLOW");
    if(fetestexcept(FE_UNDERFLOW))     printf(" FE_UNDERFLOW");
    if(fetestexcept(FE_ALL_EXCEPT)==0) printf(" none");
    printf("\n");
}
     
int main(void)
{	
  int ROUND_MODE;
	
  float a, b;


  ROUND_MODE = fegetround();		
  printf("Current Round Mode = %d \n", ROUND_MODE );
		
  show_fe_exceptions();
      
  /* Temporarily raise other exceptions */
  printf("\n Temporarily raise other exceptions");
  printf("\n 1");
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_INEXACT);
  show_fe_exceptions();
  
  printf("\n 2");  
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_INVALID);
  show_fe_exceptions();
  
  printf("\n 3");
  feclearexcept(FE_ALL_EXCEPT);    
  feraiseexcept(FE_DIVBYZERO);
  show_fe_exceptions();

  printf("\n 4");
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW);
  show_fe_exceptions();

  printf("\n 5");
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_UNDERFLOW);
  show_fe_exceptions();
  
  printf("\n 6");
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW | FE_INEXACT);
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  printf("\nBefore the operation");
  show_fe_exceptions();
  a = 0./0;
  printf("After the operation: 0./0 = %f", a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  printf("\nBefore the operation");
  show_fe_exceptions();
  a = 1 + 1e10;
  printf("After the operation: 1 + 1e10 = %f", a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  printf("\nBefore the operation");
  show_fe_exceptions();
  a = 1./0;
  printf("After the operation: 1./0 = %f", a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  printf("\nBefore the operation");
  show_fe_exceptions();
  b = 1.00001;
  a = FLT_MAX + b;
  printf("After the operation: %f + %f = %f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  printf("\nBefore the operation");
  show_fe_exceptions();
  b = 1.00001;
  a = FLT_MAX * b;
  printf("After the operation: %f * %f = %f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();

  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  printf("\nBefore the operation");
  show_fe_exceptions();
  b = 2.;
  a = FLT_MIN / b;
  printf("After the operation: %f / %f = %.40f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();
  
  printf("\nTest");
  feclearexcept(FE_ALL_EXCEPT);
  printf("\nBefore the operation");
  show_fe_exceptions();
  b = 2.1;
  a = FLT_MIN / b;
  printf("After the operation: %f / %f = %.40f", FLT_MAX, b, a);
  printf("\n");
  show_fe_exceptions();

	return 0;	
}
