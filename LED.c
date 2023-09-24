#include <mega128.h>
#include <delay.h>
#include "LED.h"
// LED1:0x10 2:0x20 3:0x40 4:0x80   //°¡ ²¨Áö´Â°Å


void IO_init(void)//LED init
{
// LED - PORTF 4,5,6,7
    PORTF &= 0x0F;
    DDRF |= 0xF0;
}

// LED1 -> LED2 (=LED1*2)
void LED_ON(int nLED)//LED_ON(LED2);
{
    PORTF &= ~(nLED);
}
                                         
void LED_OFF(int nLED)//LED OFF
{
    PORTF |= nLED;
}

