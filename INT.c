#include <mega128.h>

#include "INT.h"

void INT_init()
{
    PORTD &= 0xfc;
    DDRD &= 0xfc;
    EICRA=0x0A;
    EICRB=0x00;
    EIMSK=0x03;
    EIFR=0x03;  
    //#asm("sei")
}






