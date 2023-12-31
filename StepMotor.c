#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <math.h>


#include "StepMotor.h"
#include "Sensor.h"
#include "UART.h"
#include "Algorithm.h"
#include "LED.h"

#define PI       3.14159265358979323846
//TCNT const
#define TCNT_REF 65385
#define TCNT_LOW 65300

#define TCNT_REF_FOR_RIGHT_TURN 65387
#define TCNT_REF_FOR_LEFT_TURN 65377

#define TCNT_TURN 65150
#define TCNT_TURN_LEFT 65135

//STEP const
#define STEP_RIGHT 190
#define STEP_LEFT 220

//extern unsigned int MAP_COUNTER;

// Declare your global variables here
char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
//R모터가 전진하기 위한 8step
char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
//L모터가 전진하기 위한 8step
int LeftstepCount, RightstepCount; // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count
unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3; // 왼쪽과 오른쪽 모터의 TCNT 속도
unsigned char direction_control; // 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수
//============================================ MAP
unsigned int MAPP[500]={1};
unsigned int counter_=0;

// =====================================



int L_motorspeed=0;
int R_motorspeed=0;
int sensor_value=0;

//adjust
int adjLeftSensor, adjRightSensor;
int adjflagcnt = 0;

unsigned int vel_counter_high_L, vel_counter_high_R, vel_counter_high = 65385;
// Global variable for passing direction information to interrupt routine
unsigned char direction_control;

int ACCEL_CONTROL=0;
eeprom extern unsigned int StandardSensor[3];
eeprom extern unsigned int CenterStandardSensor[3];

struct {
int nStep4perBlock; // 한 블록 이동시 필요한 모터회전 스텝 정보
int nStep4Turn90; // 90도 턴 이동시 필요한 모터회전 스텝 정보
} Information;
struct {
char LmotorRun; // 왼쪽 모터가 회전했는지에 대한 Flag
char RmotorRun; // 오른쪽 모터가 회전했는지에 대한 Flag
} Flag;


void Acceleration(int mode)
{
    int LStepCount = 0, RStepCount = 0;
    TCCR1B = 0x04; //TIMER SET
    TCCR3B = 0x04;
    direction_control = mode;
    Flag.LmotorRun = FALSE;
    Flag.RmotorRun = FALSE;
switch(mode)
    {
        
    }
    

}





void Direction(int mode)
{
    int LStepCount = 0, RStepCount = 0;
    TCCR1B = 0x04; //TIMER SET
    TCCR3B = 0x04;
    direction_control = mode;
    Flag.LmotorRun = FALSE;
    Flag.RmotorRun = FALSE;
switch(mode)
    {
    case ACCEL_HALF:  //ACCEL
        {
        //Information.nStep4perBlock = 1527step(int)
        // TCNT_ref=65385; //모터의 속도 (65200 ~ 65535)  65400
        
        VelocityLeftmotorTCNT1 = TCNT_LOW; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
        VelocityRightmotorTCNT3 = TCNT_LOW; // 오른쪽 모터의 속도 (65200 ~ 65535)
        

            while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
            {      
                if(VelocityLeftmotorTCNT1>=TCNT_REF || VelocityRightmotorTCNT3>=TCNT_REF )
                {
                    VelocityLeftmotorTCNT1 = TCNT_REF;
                    VelocityRightmotorTCNT3 = TCNT_REF; 
                }
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
                if(ACCEL_CONTROL==1200)
                {
                    ACCEL_CONTROL=0;
                    VelocityLeftmotorTCNT1+=2;
                    VelocityRightmotorTCNT3+=2;
                }
                ACCEL_CONTROL++; 
            }
        }
        ACCEL_CONTROL=0;
        break;
        
        case DEACCEL_HALF:  //DEACCEL
        {
        //Information.nStep4perBlock=1527(int)
        // TCNT_REF 65385 //모터의 속도 (65200 ~ 65535)  65400
        //TCNT_LOW 65200
        
        VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
        VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
        

            while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
            {      
                if(VelocityLeftmotorTCNT1<=TCNT_LOW || VelocityRightmotorTCNT3<=TCNT_LOW )
                {
                    VelocityLeftmotorTCNT1 = TCNT_LOW;
                    VelocityRightmotorTCNT3 = TCNT_LOW; 
                }
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
                if(ACCEL_CONTROL==1200)
                {
                    ACCEL_CONTROL=0;
                    VelocityLeftmotorTCNT1-=1;
                    VelocityRightmotorTCNT3-=1;
                }
                ACCEL_CONTROL++; 
            }
        }
        ACCEL_CONTROL=0;
        //VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
        //VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
        
        break;
        
        case DEACCEL_HALF_STOP:  //DEACCEL
        {
        //Information.nStep4perBlock=1527(int)
        // TCNT_REF 65385 //모터의 속도 (65200 ~ 65535)  65400
        //TCNT_LOW 65200
        
        VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
        VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
        

            while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
            {      
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
                if(ACCEL_CONTROL==1200)
                {
                    ACCEL_CONTROL=0;
                    VelocityLeftmotorTCNT1-=1;
                    VelocityRightmotorTCNT3-=1;
                }
                ACCEL_CONTROL++; 
            }
        }
        ACCEL_CONTROL=0;
        //VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
        //VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
        
        break;
        
        
        /*
        case DEACCEL_WITH_HALF:  //DEACCEL
        {
    
        }
        break;
        
        case NOACCEL:  //NOACCEL
        {
    
        }
        break;
        */
        
        
        
    case ACCEL_HALF_START:  //ACCEL
        {
        //Information.nStep4perBlock=1527(int)
        // TCNT_ref=65385; //모터의 속도 (65200 ~ 65535)  65400
        
        VelocityLeftmotorTCNT1 = 65000; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
        VelocityRightmotorTCNT3 = 65000; // 오른쪽 모터의 속도 (65200 ~ 65535)
        

            while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
            {      
                if(VelocityLeftmotorTCNT1>=TCNT_REF || VelocityRightmotorTCNT3>=TCNT_REF )
                {
                    VelocityLeftmotorTCNT1 = TCNT_REF;
                    VelocityRightmotorTCNT3 = TCNT_REF; 
                }
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
                
                     if(ACCEL_CONTROL==600)
                {
                    ACCEL_CONTROL=0;
                    VelocityLeftmotorTCNT1+=2;
                    VelocityRightmotorTCNT3+=2;
                }
                ACCEL_CONTROL++; 
                
                 
            }
        }
        ACCEL_CONTROL=0;
        
        break;    
           
    case TURN_RIGHT:   //RIGHT
    
    MAPP[counter_]=TURN_RIGHT;
    counter_++; 
    VelocityLeftmotorTCNT1 = TCNT_REF_FOR_RIGHT_TURN+10; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
    VelocityRightmotorTCNT3 = TCNT_TURN+45; // 오른쪽 모터의 속도 (65200 ~ 65535)
    while(LStepCount<(STEP_RIGHT) || RStepCount<(STEP_RIGHT))
    {       
    //Information.nStep4perBlock
    
        if(Flag.LmotorRun)
        {
            LStepCount++;
            Flag.LmotorRun = FALSE;
        }
        if(Flag.RmotorRun)
        {
            RStepCount++;
            Flag.RmotorRun = FALSE;
        }
    }
    break; 
      

    
    case TURN_LEFT:   //LEFT 
    
    MAPP[counter_]=TURN_LEFT;
    counter_++;
    VelocityLeftmotorTCNT1 =TCNT_TURN_LEFT ; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
    VelocityRightmotorTCNT3 = TCNT_REF_FOR_LEFT_TURN; // 오른쪽 모터의 속도 (65200 ~ 65535)
    while(LStepCount<(STEP_LEFT) || RStepCount<(STEP_LEFT))
    {
    
        if(Flag.LmotorRun)
        {
            LStepCount++;
            Flag.LmotorRun = FALSE;
        }
        if(Flag.RmotorRun)
        {
            RStepCount++;
            Flag.RmotorRun = FALSE;
        }
    }
    break; 
        
        
    case FORWARD:  //FORWARD
    while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
    { 
    adjustmouse();
    if(Flag.LmotorRun)
    {
        LStepCount++;
        Flag.LmotorRun = FALSE;
    }
    if(Flag.RmotorRun)
    {
        RStepCount++;
        Flag.RmotorRun = FALSE;
    }
    }
    break;
      
    
    
    case HALF:        //HALF  
    LED_ON(LED4);
    while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
    {           
    
    adjustmouse();
    
    //UART
    
    if(Flag.LmotorRun)
    {
        LStepCount++;
        Flag.LmotorRun = FALSE;
    }
    if(Flag.RmotorRun)
    {
        RStepCount++;
        Flag.RmotorRun = FALSE;
    }
    }
    break; 
    
    case HALF_HALF:        //HALF  
    LED_ON(LED4);
    while(LStepCount<(Information.nStep4perBlock>>2) || RStepCount<(Information.nStep4perBlock>>2))
    {           
    
    adjustmouse();
    
    //UART
    
    if(Flag.LmotorRun)
    {
        LStepCount++;
        Flag.LmotorRun = FALSE;
    }
    if(Flag.RmotorRun)
    {
        RStepCount++;
        Flag.RmotorRun = FALSE;
    }
    }
    break; 
    
    case HALF_HALF_HALF:          
    LED_ON(LED4);
    
    MAPP[counter_]=HALF_HALF_HALF;
    counter_++;
    
    while(LStepCount<(Information.nStep4perBlock>>3) || RStepCount<(Information.nStep4perBlock>>3))
    {           
    
    adjustmouse();
    
    //UART
    
    if(Flag.LmotorRun)
    {
        LStepCount++;
        Flag.LmotorRun = FALSE;
    }
    if(Flag.RmotorRun)
    {
        RStepCount++;
        Flag.RmotorRun = FALSE;
    }
    }
    break;  
    
    
    case LEFT:    //LEFT   
    case RIGHT:   //RIGHT
    MAPP[counter_]=0;
    counter_++;
    while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
    {
    if(Flag.LmotorRun)
    {
        LStepCount++;
        Flag.LmotorRun = FALSE;
    }
    if(Flag.RmotorRun)
    {
        RStepCount++;
        Flag.RmotorRun = FALSE;
    }
    }
    break;       
    
    
    
    case BACK:    //BACK
    while(LStepCount<(Information.nStep4Turn90*2) || RStepCount<(Information.nStep4Turn90*2))
    {
    if(Flag.LmotorRun)
    {
        LStepCount++;
        Flag.LmotorRun = FALSE;
    }
    if(Flag.RmotorRun)
    {
        RStepCount++;
        Flag.RmotorRun = FALSE;
    }
    }
        break;
    }
    TCCR1B = 0x00;
    TCCR3B = 0x00;
}

void adjustmouse(void){				//직진 보정 알고리즘

    vel_counter_high=65385;
    adjLeftSensor = readSensor(LEFT_SENSOR); 		//왼쪽 센서값 읽어서 adjleft에 저장
    adjRightSensor = readSensor(RIGHT_SENSOR);	//우측 센서값 읽어서 adjright에 저장
    //printf("adj_left:%d  adj_right:%d   \ncenter_standard_left:%d     center_standard_left:%d\n",adjLeftSensor,adjRightSensor,StandardSensor[1],StandardSensor[2]); 
    
   /* vel_counter_high_L = VelocityLeftmotorTCNT1;	//현재 바퀴속도값을 변수 counter에 각각 저장(65200 ~ 65535)
    vel_counter_high_R = VelocityRightmotorTCNT3;  */

    // If none of the left and right walls are present
    if((adjRightSensor-27<StandardSensor[2]) || (adjLeftSensor-10<StandardSensor[0]))
    {	//좌우 벽중 하나가 없을 시 무조건 등속( 반대로 얘기하면 양쪽에 벽이 있어야만 좌우보정 start)
        
        vel_counter_high_L = vel_counter_high;  // Equal velocity
        vel_counter_high_R = vel_counter_high;
    }
    else{							//좌우 벽둘다 존재 할 경우 보정 시작
        // If the right wall is far
        if(adjRightSensor-27 < CenterStandardSensor[2]){		//우측 벽이 더멀면  => 정중앙보다 왼쪽에 있다
        //LED_ON(LED4);/////////////////////////////////////// 
       /* printf("%d  \t%d \t %d \t %d\r\n",adjRightSensor,readSensor(RIGHT_SENSOR),CenterStandardSensor[0],CenterStandardSensor[2]);
              delay_ms(1000);*/
        
        
        
            vel_counter_high_L+=1;				//좌측 속도 높이고
            vel_counter_high_R-=1;				//우측 속도 down	1의 값을 높이면 변하는 tempo를 더 빠르게 할 수 있음
            if(vel_counter_high_L > vel_counter_high+20){		//속도 변화량의 최대값 설정 아무리 높아도 +20정도까지만 되게
                vel_counter_high_L = vel_counter_high+20; 
            }
            if(vel_counter_high_R < (vel_counter_high-20)){
                vel_counter_high_R = (vel_counter_high-20);
            }
        }else{
            adjflagcnt++;					//카운트 1증가
        }
        // If the left wall is far
        if(adjLeftSensor-10 < CenterStandardSensor[0]){		//좌측벽도 마찬가지로 진행
            vel_counter_high_L-=1;
            vel_counter_high_R+=1;
            if(vel_counter_high_R > vel_counter_high+20){
                vel_counter_high_R = vel_counter_high+20; 
            }
            if(vel_counter_high_L < (vel_counter_high-20)){
                vel_counter_high_L = (vel_counter_high-20);
            }
        }else{
            adjflagcnt++;					//카운트 1중가
        }
        // If both left and right walls are not far away
        if(adjflagcnt==2){					//둘다 보정 후에 값 입력
            vel_counter_high_L = vel_counter_high;  // Equal velocity
            vel_counter_high_R = vel_counter_high;
        }
    }
    VelocityLeftmotorTCNT1 = vel_counter_high_L;
    VelocityRightmotorTCNT3 = vel_counter_high_R;  

}





// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
switch(direction_control)
{
    case LEFT:
    PORTD |= (rotateL[LeftstepCount]<<4);
    PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
    LeftstepCount--;
    if(LeftstepCount < 0)
    LeftstepCount = sizeof(rotateL)-1;
    break;
    
    case RIGHT:
    case BACK:
    case FORWARD:
    case HALF:
    case ACCEL_HALF:
    case DEACCEL_HALF:
    case DEACCEL_HALF_STOP:  //DEACCEL 
    case ACCEL_HALF_START: 
    case TURN_RIGHT:   //RIGHT
    case TURN_LEFT:
    case HALF_HALF:
    case HALF_HALF_HALF: 
    PORTD |= (rotateL[LeftstepCount]<<4);
    PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
    LeftstepCount++;
    LeftstepCount %= sizeof(rotateL);
    break;
}

Flag.LmotorRun = TRUE;
TCNT1H = VelocityLeftmotorTCNT1 >> 8;
TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
}




// Timer 3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
// Place your code here
switch(direction_control)
{
case RIGHT:
case BACK:
PORTE |= (rotateR[RightstepCount]<<4);
PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
RightstepCount--;
if(RightstepCount < 0)
RightstepCount = sizeof(rotateR)-1;
break;
case FORWARD:
case HALF:
case LEFT:
case ACCEL_HALF:
case DEACCEL_HALF:
case DEACCEL_HALF_STOP:  //DEACCEL
case ACCEL_HALF_START:
case TURN_RIGHT:
case TURN_LEFT:
case HALF_HALF: 
case HALF_HALF_HALF:
PORTE |= (rotateR[RightstepCount]<<4);
PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
RightstepCount++;
RightstepCount %= sizeof(rotateR);
break;
}
Flag.RmotorRun = TRUE;
TCNT3H = VelocityRightmotorTCNT3 >> 8;
TCNT3L = VelocityRightmotorTCNT3 & 0xff;
}





void InitializeStepMotor(void)
{
double distance4perStep;

// LEFT MOTOR - PORTD 4,5,6,7
PORTD&=0x0F;
DDRD|=0xF0;
// RIGHT MOTOR - PORTE 4,5,6,7
PORTE&=0x0F;
DDRE|=0xF0;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 62.500 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x04;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;
// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 62.500 kHz
// Mode: Normal top=FFFFh
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 3 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x04;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x04;
ETIMSK=0x04;


distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
//0.1178(mm)
Information.nStep4perBlock = (int)((double)180. / distance4perStep);
//1527.88(step)
Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);

//Information.nStep4Turn90_RIGHT_WHEEL = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);
//Information.nStep4Turn90_LEFT_WHEEL = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);

//====================
LeftstepCount=0;
RightstepCount=0;

#asm("sei")
VelocityLeftmotorTCNT1 = 65385; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
VelocityRightmotorTCNT3 = 65385; // 오른쪽 모터의 속도 (65200 ~ 65535)
//====================

}















