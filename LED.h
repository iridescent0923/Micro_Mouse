#ifndef _LED_H_
#define _LED_H_
#define LED1 0x10
#define LED2 0x20
#define LED3 0x40
#define LED4 0x80
void IO_init(void);//LED init
void LED_ON(int nLED);
void LED_OFF(int nLED);
#endif