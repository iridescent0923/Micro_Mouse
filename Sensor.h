#ifndef _Sensor_h_
#define _Sensor_h_
#define FRONT_SENSOR 0
#define LEFT_SENSOR 1
#define RIGHT_SENSOR 2
#define ADC_VREF_TYPE 0x40
void InitializeSensor(void);
unsigned int readSensor(char si);
#endif