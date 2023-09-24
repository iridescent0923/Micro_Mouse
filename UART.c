#include <mega128.h>
#include "UART.h"

// Write a character to the USART1 Transmitter
void putchar(char c){
    while((UCSR1A & DATA_REGISTER_EMPTY)==0);
    UDR1=c;
}

// Read a character from the USART1 Receiver



unsigned char getchar(void){
    while((UCSR1A & RX_COMPLETE)==0);
    return UDR1;
}



void InitializeUART(void){
    // USART1 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud Rate: 9600
    UCSR1A=0x00;
    UCSR1B=0x18;
    UCSR1C=0x06;
    UBRR1H=0x00;
    UBRR1L=0x67;
}