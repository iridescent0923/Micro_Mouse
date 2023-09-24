#include <mega128.h>
#include <stdio.h>
#include <delay.h>
#include "Sensor.h"
#include "StepMotor.h"
#include "LED.h"
#include "Switch.h"
#include "Algorithm.h"
#include "UART.h"

// Declare your global variables here
extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
extern unsigned int adjLeftSensor, adjRightSensor;
extern unsigned int MAPP[500],counter_;




unsigned int mode =0;
unsigned int mode_UART=0;
unsigned int AVG=0;
eeprom unsigned int CANCEL_FLAG=0;             
eeprom unsigned int StandardSensor[3] = {0};
eeprom unsigned int CenterStandardSensor[3] ={0};
float ref_leftSensor =0, ref_rightSensor=0;
int i;
int PRINTF_COUNTER=0;

// SEARCH
/*
#define FORWARD 4
#define LEFT 5
#define RIGHT 6
#define BACK 7
#define HALF 8

#define ACCEL_HALF 9
#define DEACCEL_HALF 10
#define DEACCEL_HALF_STOP 11
#define ACCEL_HALF_START 12
#define TURN_RIGHT 13   //RIGHT
#define TURN_LEFT 14
#define HALF_HALF 15
#define HALF_HALF_HALF 16
*/
eeprom unsigned int MAP[1000]={1};
eeprom unsigned int MAP_COUNTER=0;
unsigned int MAP_COUNTER_DRIVE=0;
unsigned int DRIVE_COUNTER=0;

void CANCEL()
{
     // 180도 canceling
        for(i=0;i<MAP_COUNTER;i++)
        {
            if((MAP[i]==0) && (MAP[i+1]==0) ) //첫번째 0
            {
                    if(MAP[i-2]==TURN_LEFT)
                    {
                        MAP[i-2]=HALF_HALF;
                        MAP[i-1]=1;//pass sign
                        MAP[i]=1;
                        MAP[i+1]=1; 
                        MAP[i+2]=1;
                        MAP[i+3]=1;
                        MAP[i+4]=1;    
                    }
                    else //RIGHT였으면
                    {
                        MAP[i-2]=TURN_LEFT; //RIGHT to LEFT
                        MAP[i-1]=1;//pass sign
                        MAP[i]=1;
                        MAP[i+1]=1; 
                        MAP[i+2]=1;
                        MAP[i+3]=1;
                        MAP[i+4]=1;
                    }    
            }   
            
        
        }
        for(i=0;i<10;i++)
        {
            LED_ON(LED3);
            delay_ms(100);
            LED_OFF(LED3);
            delay_ms(100);                
        }
        CANCEL_FLAG=1;

}

void main(void)
{
    InitializeSensor();
    InitializeStepMotor();
    IO_init();
    InitializeSwitch();
    InitializeUART();
    #asm("sei");
    
    // sensor const 
        // 벽유무 
        /*legacy
        StandardSensor[0] = 20; // left
        StandardSensor[1] = 30; // front
        StandardSensor[2] = 84; // right
        */
        
        StandardSensor[0] = 29; // left
        StandardSensor[1] = 60; // front  30  70
        StandardSensor[2] = 84; // right
        
        // 가운데 있나? = 직진보정 
        /* legacy
        CenterStandardSensor[0] =(45);   //left   45+10
        CenterStandardSensor[1] = 480;    //front
        CenterStandardSensor[2] = (125);   //right   125+27  
        */
        
        CenterStandardSensor[0] =(65);   //left   45+10
        CenterStandardSensor[1] = 480;    //front
        CenterStandardSensor[2] = (153);   //right   125+27
    
    
    //=======================================
    
    while(1)
{
if(SW1() == TRUE)
{
    mode++;
    mode%=4;
    LED_OFF(LED1 | LED2 | LED3 | LED4);
    switch(mode)
    {
        case 0: LED_ON(LED1); break;
        case 1: LED_ON(LED2); break;
        case 2: LED_ON(LED3); break;
        case 3: LED_ON(LED4); break;
    }  
}


if(SW2() == TRUE)
{
    switch(mode)
    {
    //좌수법 테스트
    case 0:
    {
        /*
        ACCEL_HALF_START 12
        DEACCEL_HALF_STOP 11
         
        ACCEL_HALF 9
        DEACCEL_HALF 10
        
        TURN_RIGHT 13
        TURN_LEFT 14 
        */        

        LED_OFF(LED1 | LED2 | LED3 | LED4);
        delay_ms(1000);                    
        Direction(ACCEL_HALF);
        delay_ms(80);
        while (1){
                    if( (readSensor(LEFT_SENSOR))-10 < StandardSensor[0]) // read -10
                    {//왼쪽으로 갈 수 있으면 
                        //delay_ms(5000);
                        			
                        LED_ON(LED3);
                        LED_OFF(LED4);
                        //Direction(HALF_HALF);
                        Direction(TURN_LEFT); 
                        //delay_ms(500);
                        LED_OFF(LED3);
                        LED_OFF(LED4);
                        //Direction(HALF_HALF_HALF);
                        //Direction(HALF_HALF);
                        //delay_ms(5000);
                    }
                    
                     
                    
                    
                    if(readSensor(FRONT_SENSOR) > StandardSensor[1] &&( (readSensor(LEFT_SENSOR))-10 > StandardSensor[0] ) ) //-10 뺌
                    {
                                //앞이 막혀있고
                                //delay_ms(5000)        
                        if(readSensor(RIGHT_SENSOR)-30 < StandardSensor[2])
                        {//우측이 열려있으면
                            
                            LED_OFF(LED3);
                            LED_ON(LED4);
                            Direction(HALF_HALF_HALF);
                            Direction(TURN_RIGHT); 
                            //delay_ms(5000);
                            //delay_ms(500);
                            LED_OFF(LED3);
                            LED_OFF(LED4); 
                            //Direction(HALF_HALF);

                        }
                        else if(
                        ( (readSensor(LEFT_SENSOR)-40) > StandardSensor[0]) && 
                        (readSensor(RIGHT_SENSOR)-40) > StandardSensor[2] )
                        {    
                                                    //삼면 다 막힘 = U_TURN
                            LED_ON(LED3);
                            LED_ON(LED4); 
                            
                            Direction(HALF_HALF_HALF);
                            Direction(LEFT);
                            Direction(LEFT);
                            Direction(HALF_HALF_HALF);
                            
                        }
                        
                    } 
                    
                    else
                    {                        //좌우가  막히고 앞이 열려있으면 = 직진
                        LED_OFF(LED3);
                        LED_OFF(LED4);
                        
                        Direction(HALF_HALF_HALF); //FORWARD
                        
                    }
                }
        
        //=======================
        
     
        break;
    }


    //센서 uart===================================================================
    case 1:
    {       
        
        LED_OFF(LED1 | LED2 | LED3 | LED4);
        
        while(1)
        {
            
            if(SW1() == TRUE)
            {
                mode_UART++;
                mode_UART%=4;
                LED_OFF(LED1 | LED2 | LED3 | LED4);
                switch(mode_UART)
                {
                    case 0: LED_ON(LED1); break;
                    case 2: LED_ON(LED3); break;
                    case 3: LED_ON(LED4); break;
                }  
            }
        
        
        
        
    if(SW2() == TRUE)
    switch(mode_UART)
    {
        
        {
        case 0:
        
        {
            {
            printf("\t\r\n============\t\r\n");            
            for(i=0;i<MAP_COUNTER+1;i++)
            {
                if(PRINTF_COUNTER == 5)
                {
                    printf("\t\r\n");
                    PRINTF_COUNTER=0;
                } 
                printf("%d\t",MAP[i]);
                PRINTF_COUNTER++;    
            }
                printf("\t\r\n============\t\r\n");
                PRINTF_COUNTER=0;
                
            LED_ON(LED1 | LED2 | LED3 | LED4);
            delay_ms(1500);
            LED_OFF(LED1 | LED2 | LED3 | LED4);
            }
            break;
        }
        
        case 2:
        {   
            if(CANCEL_FLAG==1)
            {
        
            }
            else
                CANCEL();
            break;
        }
        
        
        
        
        
        case 3://RESET
                    {
                        LED_OFF(LED1 | LED2 | LED3 | LED4);
                        
                        for(i=0;i<1000;i++)
                        {
                            MAP[i]=1;
                        }
                        
                        MAP_COUNTER=0;
                        for(i=0;i<5;i++)
                        {
                            LED_ON(LED1 | LED2 | LED3 | LED4);
                            delay_ms(100);
                            LED_OFF(LED1 | LED2 | LED3 | LED4);
                            delay_ms(100);
                        
                        }
                        CANCEL_FLAG=0;    
                        break;
                    }
                    
        
        }    
        }//SWITCH
    
    
    }//while              끝
    }//end of cane1: UART
    
    //MAP READING
    case 2:
    { 
        /*
        초기화 = 1
        180turn구간 = 0
        정지입력 = 99
        #define FORWARD 4
        #define LEFT 5
        #define RIGHT 6
        #define BACK 7
        #define HALF 8

        #define ACCEL_HALF 9
        #define DEACCEL_HALF 10
        #define DEACCEL_HALF_STOP 11
        #define ACCEL_HALF_START 12                                                          
        #define TURN_RIGHT 13   //RIGHT
        #define TURN_LEFT 14
        #define HALF_HALF 15
        #define HALF_HALF_HALF 16
        */
        
        
        LED_OFF(LED1 | LED2 | LED3 | LED4);
        for(i=0;i<MAP_COUNTER;i++)
        {
            MAP[i]=1;
        }
                        
        MAP_COUNTER=0;
        for(i=0;i<5;i++)
        {
            LED_ON(LED1 | LED2 | LED3 | LED4);
            delay_ms(100);
            LED_OFF(LED1 | LED2 | LED3 | LED4);
            delay_ms(100);                
        }
        CANCEL_FLAG=0;
                        
        // search init
        MAP[0]=ACCEL_HALF;
        MAP_COUNTER++; 
        
        LED_OFF(LED1 | LED2 | LED3 | LED4);
        delay_ms(500);                    
        Direction(ACCEL_HALF);
        delay_ms(80);
        
        
       while (1){
                    if(SW2() == TRUE)//정지 눌리면 멈추고 경로 저장
                    {
                        LED_ON(LED1 | LED2 | LED3 | LED4);
                        MAP_COUNTER=counter_;
                        for(i=0;i<counter_;i++)
                        {
                            MAP[i]=MAPP[i];
                        } 
                        MAP[counter_+1]=99; //end sign
                        MAP_COUNTER++;
                        break;
                        delay_ms(100000);
                    }
                    
                    
                    
                    
                    if( (readSensor(LEFT_SENSOR))-12 < StandardSensor[0]) // read -10
                    {//왼쪽으로 갈 수 있으면 
                        //delay_ms(5000);
                                    
                        LED_ON(LED3);
                        LED_OFF(LED4);
                        //Direction(HALF_HALF);
                        Direction(TURN_LEFT); 
                        //delay_ms(500);
                        LED_OFF(LED3);
                        LED_OFF(LED4);
                        //Direction(HALF_HALF_HALF);
                        //Direction(HALF_HALF);
                        //delay_ms(5000);
                    }
                    
                     
                    
                    
                    if(readSensor(FRONT_SENSOR) > StandardSensor[1] &&( (readSensor(LEFT_SENSOR))-10 > StandardSensor[0] ) ) //-10 뺌
                    {
                                //앞이 막혀있고
                                //delay_ms(5000)        
                        if(readSensor(RIGHT_SENSOR)-30 < StandardSensor[2])
                        {//우측이 열려있으면
                            
                            LED_OFF(LED3);
                            LED_ON(LED4);
                            Direction(HALF_HALF_HALF);
                            Direction(TURN_RIGHT); 
                            //delay_ms(5000);
                            //delay_ms(500);
                            LED_OFF(LED3);
                            LED_OFF(LED4); 
                            //Direction(HALF_HALF);

                        }
                        else if(
                        ( (readSensor(LEFT_SENSOR)-40) > StandardSensor[0]) && 
                        (readSensor(RIGHT_SENSOR)-40) > StandardSensor[2] )
                        {    
                                                    //삼면 다 막힘 = U_TURN
                            LED_ON(LED3);
                            LED_ON(LED4); 
                            
                            Direction(HALF_HALF_HALF);
                            Direction(LEFT);
                            Direction(LEFT);
                            Direction(HALF_HALF_HALF);
                            
                        }
                        
                    } 
                    
                    else
                    {                        //좌우가  막히고 앞이 열려있으면 = 직진
                        LED_OFF(LED3);
                        LED_OFF(LED4);
                        
                        Direction(HALF_HALF_HALF); //FORWARD
                        //MAP[MAP_COUNTER]=HALF_HALF_HALF;
                        
                        
                    }
                }

        
    }

    //MAP BASED_DRIVE
    case 3:
    { 
        /*
        ACCEL_HALF_START 12
        DEACCEL_HALF_STOP 11
         
        ACCEL_HALF 9
        DEACCEL_HALF 10
        
        TURN_RIGHT 13
        TURN_LEFT 14
        
        0 = 180도 turn
        1=skip
        99 = 맵 끝 
        */     
        for(i=0;i<5;i++)
        {
            LED_ON(LED1 | LED2 | LED3 | LED4);
            delay_ms(100);
            LED_OFF(LED1 | LED2 | LED3 | LED4);
            delay_ms(100);                
        }
        
        if(DRIVE_COUNTER==0 && CANCEL_FLAG==0) //최초실행 + CANCEL NONE
        {
            CANCEL();
            CANCEL_FLAG=1;
            //=======================
            delay_ms(1000);
            Direction(ACCEL_HALF);
            while(1)
            {
                if(MAP[DRIVE_COUNTER]==99)
                {
                    Direction(DEACCEL_HALF_STOP);
                    DRIVE_COUNTER=0;
                    break;
                }
            
                if(MAP[DRIVE_COUNTER]==0 || MAP[DRIVE_COUNTER]==1)//pass
                {
                    DRIVE_COUNTER++;
            
                }
                else
                {
                    Direction(MAP[DRIVE_COUNTER]);
                    DRIVE_COUNTER++;
                }
            } //end of while    
        
        }
        
        else 
            delay_ms(1000);
            Direction(ACCEL_HALF);
            while(1)
            {
                if(MAP[DRIVE_COUNTER]==99)
                {
                    Direction(DEACCEL_HALF_STOP);
                    DRIVE_COUNTER=0;
                    break;
                }
            
                if(MAP[DRIVE_COUNTER]==0 || MAP[DRIVE_COUNTER]==1)//pass
                {
                    DRIVE_COUNTER++;
            
                }
                else
                {
                    Direction(MAP[DRIVE_COUNTER]);
                    DRIVE_COUNTER++;
                }
            } //end of while   
            
            
            
            break;
        } 

    
    
}
}
}

}
