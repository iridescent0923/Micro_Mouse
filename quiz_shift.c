/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2020-09-16
Author  : 
Company : 
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128.h>
#include <delay.h>
#include "LED.h"

int current_LED=0x80; //current
int counter=0;

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void) //sw1:1falling 
{
    if(counter==4)
    {
     counter=0;    
     PORTF=0x00;
     current_LED=0x80;
    }
    
      else if(counter>=1)// on count
      {
        PORTF=~(~current_LED>>1); //오른쪽으로 shift해야  
        current_LED=PORTF;
      
      }
     
    counter++;
    delay_ms(1000);


}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void) //sw2:reset
{
    counter=0;
    PORTF=0x00;

}



void main(void)
{

EICRA=0x08;
EICRB=0x00;
EIMSK=0x03;
EIFR=0x03;
#asm("sei")

InitializeLED();

while (1)
      {
      
      
    

      }
}
