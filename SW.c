#include <mega128.h>
#include "switch.h"
#include "LED.h"
// Declare your global variables here
struct Buttons{
char SW1;
char SW2;
} ;
Buttons Button;


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
Button.SW1 = TRUE;
}
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
Button.SW2 = TRUE;
}



char SW1(void)
{
char ret;
ret = Button.SW1;
Button.SW1 = FALSE;
return ret;
}
char SW2(void)
{
char ret;
ret = Button.SW2;
Button.SW2 = FALSE;
return ret;
}

void InitializeSwitch(void)
{
// ����ġ PORTD 0,1
PORTD &= 0xfc;
DDRD &= 0xfc;
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x0A;
EICRB=0x00;
EIMSK=0x03;
EIFR=0x03;
}

void main(void)
{
// Declare your local variables here
InitializeSwitch();
InitializeLED();
Button.SW1 = FALSE;
Button.SW2 = FALSE;
// Global enable interrupts
#asm("sei")
while (1)
{
// Place your code here
if(SW1() == TRUE)
{
LED_ON(LED1);
LED_ON(LED2);
LED_OFF(LED3);
LED_OFF(LED4);
}
if(SW2() == TRUE)
{
LED_OFF(LED1);
LED_OFF(LED2);
LED_ON(LED3);
LED_ON(LED4);
}
};
}


