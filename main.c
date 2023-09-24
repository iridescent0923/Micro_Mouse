#include <mega128.h>
#include <delay.h>

#include "LED.h"
#include "INT.h"
#include "Sensor.h"
#include "UART.h"
#include "StepMotor.h"





interrupt [EXT_INT0] void ext_int0_isr(void) //sw1
{  
    PORTF=0x00;
    delay_ms(1000);        

}


interrupt [EXT_INT1] void ext_int1_isr(void) //sw2
{
    PORTF=0xff;
    delay_ms(1000); 

}


void main(void)
{
    IO_init();
    INT_init();
    InitializeSensor();
    InitializeUART();
    
    InitializeStepMotor();

// Global enable interrupts
#asm("sei")



while (1)
{
// Place your code here
};
    
   
}









