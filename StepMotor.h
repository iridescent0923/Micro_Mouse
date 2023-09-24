#ifndef _StepMotor_h_
#define _StepMotor_h_
#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif
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


#define TIRE_RAD 51. // unit : mm
#define MOUSE_WIDTH 82. // unit : mm (Ÿ�̾� �߰�)
#define MOUSE_LENGTH 114. // unit : mm
#define MOTOR_STEP 400 // unit : step
void InitializeStepMotor(void);
void Direction(int mode);
void Acceleration(int mode);
void adjustmouse(void);

#endif