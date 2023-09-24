
#include <mega128.h>
#include <delay.h>
#include <math.h>
#include "LED.h"



int LED=LED1;
int store;
int flag=0;



interrupt [EXT_INT0] void ext_int0_isr(void)//sw1   
{
    if(flag==1)
    {

    }
    
    
    else if(flag==0 && LED==LED4)
    {
    LED=LED1;
    flag=1;
    
    }
    else
    
    LED*=2;
    flag=1;
    
    
 


}


interrupt [EXT_INT1] void ext_int1_isr(void)//sw2
{
   LED=LED1;
   


}





void main(void)
{

EICRA=0b00001010;
EICRB=0x00;
EIMSK=0x03;
EIFR=0x03;

// Global enable interrupts
#asm("sei")

IO_init();




while(1)
{
    if(flag==1)
    {
        
        PORTF=0xff;
        LED_ON(LED);
        delay_ms(1000);
          
        flag=0;
        
    
    }
    LED_ON(LED);
    PORTF=0xff;
    
    
      
       
      
      

      
}

}
