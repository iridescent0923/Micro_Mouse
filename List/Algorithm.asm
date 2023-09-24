
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R4
	.DEF _mode_UART=R6
	.DEF _AVG=R8
	.DEF _i=R10
	.DEF _PRINTF_COUNTER=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x27:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x9
	.DB  0xD,0xA,0x0,0x25,0x64,0x9,0x0
_0x40003:
	.DB  0x9,0x1,0x5,0x4,0x6,0x2,0xA,0x8
_0x40004:
	.DB  0x9,0x8,0xA,0x2,0x6,0x4,0x5,0x1
_0x40005:
	.DB  0x1
_0x40006:
	.DB  0x69,0xFF
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  _0x27*2

	.DW  0x08
	.DW  _rotateR
	.DW  _0x40003*2

	.DW  0x08
	.DW  _rotateL
	.DW  _0x40004*2

	.DW  0x01
	.DW  _MAPP
	.DW  _0x40005*2

	.DW  0x02
	.DW  _vel_counter_high
	.DW  _0x40006*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <delay.h>
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "Switch.h"
;#include "Algorithm.h"
;#include "UART.h"
;
;// Declare your global variables here
;extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
;extern unsigned int adjLeftSensor, adjRightSensor;
;extern unsigned int MAPP[500],counter_;
;
;
;
;
;unsigned int mode =0;
;unsigned int mode_UART=0;
;unsigned int AVG=0;
;eeprom unsigned int CANCEL_FLAG=0;
;eeprom unsigned int StandardSensor[3] = {0};
;eeprom unsigned int CenterStandardSensor[3] ={0};
;float ref_leftSensor =0, ref_rightSensor=0;
;int i;
;int PRINTF_COUNTER=0;
;
;// SEARCH
;/*
;#define FORWARD 4
;#define LEFT 5
;#define RIGHT 6
;#define BACK 7
;#define HALF 8
;
;#define ACCEL_HALF 9
;#define DEACCEL_HALF 10
;#define DEACCEL_HALF_STOP 11
;#define ACCEL_HALF_START 12
;#define TURN_RIGHT 13   //RIGHT
;#define TURN_LEFT 14
;#define HALF_HALF 15
;#define HALF_HALF_HALF 16
;*/
;eeprom unsigned int MAP[100]={16,16,16,16,16,16,15,1,1,1,1,15,16,16,16,16,16,15,1,1,1,1,15,16,16,16,16,16,16,16,16,16,0,99};
;
;eeprom unsigned int MAP_COUNTER=0;
;unsigned int MAP_COUNTER_DRIVE=0;
;unsigned int DRIVE_COUNTER=0;
;
;void CANCEL()
; 0000 0035 {

	.CSEG
; 0000 0036      // 180도 canceling
; 0000 0037         for(i=0;i<MAP_COUNTER;i++)
; 0000 0038         {
; 0000 0039             if((MAP[i]==0) ) //첫번째 0
; 0000 003A             {
; 0000 003B                     if(MAP[i-1]==TURN_LEFT)
; 0000 003C                     {
; 0000 003D                         MAP[i-2]=1;
; 0000 003E                         MAP[i-1]=1;//pass sign
; 0000 003F                         MAP[i]=1;
; 0000 0040                         MAP[i+1]=1;
; 0000 0041                         MAP[i+2]=1;
; 0000 0042                         MAP[i+3]=1;
; 0000 0043                         MAP[i+4]=1;
; 0000 0044                     }
; 0000 0045                     else //RIGHT였으면
; 0000 0046                     {
; 0000 0047                         MAP[i-2]=TURN_LEFT; //RIGHT to LEFT
; 0000 0048                         MAP[i-1]=1;//pass sign
; 0000 0049                         MAP[i]=1;
; 0000 004A                         MAP[i+1]=1;
; 0000 004B                         MAP[i+2]=1;
; 0000 004C                         MAP[i+3]=1;
; 0000 004D                         MAP[i+4]=1;
; 0000 004E                     }
; 0000 004F             }
; 0000 0050 
; 0000 0051 
; 0000 0052         }
; 0000 0053         for(i=0;i<10;i++)
; 0000 0054         {
; 0000 0055             LED_ON(LED3);
; 0000 0056             delay_ms(100);
; 0000 0057             LED_OFF(LED3);
; 0000 0058             delay_ms(100);
; 0000 0059         }
; 0000 005A         CANCEL_FLAG=1;
; 0000 005B 
; 0000 005C }
;
;void main(void)
; 0000 005F {
_main:
; 0000 0060     InitializeSensor();
	RCALL _InitializeSensor
; 0000 0061     InitializeStepMotor();
	CALL _InitializeStepMotor
; 0000 0062     IO_init();
	CALL _IO_init
; 0000 0063     InitializeSwitch();
	CALL _InitializeSwitch
; 0000 0064     InitializeUART();
	CALL _InitializeUART
; 0000 0065     #asm("sei");
	sei
; 0000 0066 
; 0000 0067     // sensor const
; 0000 0068         // 벽유무
; 0000 0069         /*legacy
; 0000 006A         StandardSensor[0] = 20; // left
; 0000 006B         StandardSensor[1] = 30; // front
; 0000 006C         StandardSensor[2] = 84; // right
; 0000 006D         */
; 0000 006E 
; 0000 006F         StandardSensor[0] = 29; // left
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	CALL __EEPROMWRW
; 0000 0070         StandardSensor[1] = 60; // front  30  70
	__POINTW2MN _StandardSensor,2
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __EEPROMWRW
; 0000 0071         StandardSensor[2] = 84; // right
	__POINTW2MN _StandardSensor,4
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL __EEPROMWRW
; 0000 0072 
; 0000 0073         // 가운데 있나? = 직진보정
; 0000 0074         /* legacy
; 0000 0075         CenterStandardSensor[0] =(45);   //left   45+10
; 0000 0076         CenterStandardSensor[1] = 480;    //front
; 0000 0077         CenterStandardSensor[2] = (125);   //right   125+27
; 0000 0078         */
; 0000 0079 
; 0000 007A         CenterStandardSensor[0] =(65);   //left   45+10
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	CALL __EEPROMWRW
; 0000 007B         CenterStandardSensor[1] = 480;    //front
	__POINTW2MN _CenterStandardSensor,2
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	CALL __EEPROMWRW
; 0000 007C         CenterStandardSensor[2] = (153);   //right   125+27
	__POINTW2MN _CenterStandardSensor,4
	LDI  R30,LOW(153)
	LDI  R31,HIGH(153)
	CALL __EEPROMWRW
; 0000 007D 
; 0000 007E 
; 0000 007F     //=======================================
; 0000 0080 
; 0000 0081     while(1)
_0xC:
; 0000 0082 {
; 0000 0083 if(SW1() == TRUE)
	CALL _SW1
	CPI  R30,LOW(0x1)
	BRNE _0xF
; 0000 0084 {
; 0000 0085     mode++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0086     mode%=4;
	LDI  R30,LOW(3)
	AND  R4,R30
	CLR  R5
; 0000 0087     LED_OFF(LED1 | LED2 | LED3 | LED4);
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	ST   -Y,R31
	ST   -Y,R30
	CALL _LED_OFF
; 0000 0088     switch(mode)
	MOVW R30,R4
; 0000 0089     {
; 0000 008A         case 0: LED_ON(LED1); break;
	SBIW R30,0
	BRNE _0x13
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x26
; 0000 008B         case 1: LED_ON(LED2); break;
_0x13:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RJMP _0x26
; 0000 008C         case 2: LED_ON(LED3); break;
_0x14:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x15
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP _0x26
; 0000 008D         case 3: LED_ON(LED4); break;
_0x15:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x12
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
_0x26:
	ST   -Y,R31
	ST   -Y,R30
	CALL _LED_ON
; 0000 008E     }
_0x12:
; 0000 008F }
; 0000 0090 
; 0000 0091 
; 0000 0092 if(SW2() == TRUE)
_0xF:
	CALL _SW2
	CPI  R30,LOW(0x1)
	BRNE _0x17
; 0000 0093 {
; 0000 0094     switch(mode)
	MOVW R30,R4
; 0000 0095     {
; 0000 0096 
; 0000 0097     case 0:
	SBIW R30,0
	BRNE _0x1A
; 0000 0098     printf("=======================\t\r\n");
	CALL SUBOPT_0x0
; 0000 0099 
; 0000 009A     for(i=0;i<100;i++)
	CLR  R10
	CLR  R11
_0x1D:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x1E
; 0000 009B     {
; 0000 009C         if(MAP[i]==99)
	CALL SUBOPT_0x1
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x1F
; 0000 009D         {
; 0000 009E             printf("%d\t",MAP[i]);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 009F             printf("\t\r\n");
; 0000 00A0 
; 0000 00A1             break;
	RJMP _0x1E
; 0000 00A2 
; 0000 00A3         }
; 0000 00A4         if(i!=0 && i%5==0)
_0x1F:
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BREQ _0x21
	MOVW R26,R10
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	SBIW R30,0
	BREQ _0x22
_0x21:
	RJMP _0x20
_0x22:
; 0000 00A5         {
; 0000 00A6             printf("%d\t",MAP[i]);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 00A7             printf("\t\r\n");
; 0000 00A8 
; 0000 00A9 
; 0000 00AA         }
; 0000 00AB         else
	RJMP _0x23
_0x20:
; 0000 00AC         {
; 0000 00AD             printf("%d\t",MAP[i]);
	CALL SUBOPT_0x2
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 00AE         }
_0x23:
; 0000 00AF 
; 0000 00B0     }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x1D
_0x1E:
; 0000 00B1     printf("=======================\t\r\n");
	CALL SUBOPT_0x0
; 0000 00B2 
; 0000 00B3 
; 0000 00B4 
; 0000 00B5 
; 0000 00B6 
; 0000 00B7 
; 0000 00B8 
; 0000 00B9     }
_0x1A:
; 0000 00BA }
; 0000 00BB }
_0x17:
	RJMP _0xC
; 0000 00BC 
; 0000 00BD }
_0x24:
	RJMP _0x24
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;// Standard Input/Output functions
;#include <stdio.h>
;#include "Sensor.h"
;#include "UART.h"
;#include "LED.h"
;
;#define ADC_VREF_TYPE 0x40
;
;void InitializeSensor(void)
; 0001 000C {

	.CSEG
_InitializeSensor:
; 0001 000D // 발광센서 PORTB 5,6,7
; 0001 000E PORTB &= 0x1f;
	IN   R30,0x18
	ANDI R30,LOW(0x1F)
	OUT  0x18,R30
; 0001 000F DDRB |= 0xe0;
	IN   R30,0x17
	ORI  R30,LOW(0xE0)
	OUT  0x17,R30
; 0001 0010 // 수광센서 PORTF 0,1,2
; 0001 0011 PORTF &= 0xf8;
	LDS  R30,98
	ANDI R30,LOW(0xF8)
	STS  98,R30
; 0001 0012 DDRF &= 0xf8;
	LDS  R30,97
	ANDI R30,LOW(0xF8)
	STS  97,R30
; 0001 0013 // ADC initialization
; 0001 0014 // ADC Clock frequency: 125.000 kHz
; 0001 0015 // ADC Voltage Reference: AVCC pin
; 0001 0016 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0001 0017 ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0001 0018 }
	RET
;
;
;unsigned int read_adc(unsigned char adc_input)
; 0001 001C {
; 0001 001D     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0001 001E     // Delay needed for the stabilization of the ADC input voltage
; 0001 001F     delay_us(10);
; 0001 0020     // Start the AD conversion
; 0001 0021     ADCSRA|=0x40;
; 0001 0022     // Wait for the AD conversion to complete
; 0001 0023     while ((ADCSRA & 0x10)==0);
; 0001 0024     ADCSRA|=0x10;
; 0001 0025     return ADCW;
; 0001 0026 }
;
;unsigned int readSensor(char si)
; 0001 0029 {
; 0001 002A unsigned int ret;
; 0001 002B switch(si)
;	si -> Y+2
;	ret -> R16,R17
; 0001 002C {
; 0001 002D case FRONT_SENSOR:
; 0001 002E PORTB.5=1;
; 0001 002F delay_us(50);
; 0001 0030 ret=read_adc(si);
; 0001 0031 PORTB.5=0;
; 0001 0032 break;
; 0001 0033 case LEFT_SENSOR:
; 0001 0034 PORTB.6=1;
; 0001 0035 delay_us(50);
; 0001 0036 ret=read_adc(si);
; 0001 0037 PORTB.6=0;
; 0001 0038 break;
; 0001 0039 case RIGHT_SENSOR:
; 0001 003A PORTB.7=1;
; 0001 003B delay_us(50);
; 0001 003C ret=read_adc(si);
; 0001 003D PORTB.7=0;
; 0001 003E break;
; 0001 003F }
; 0001 0040 return ret;
; 0001 0041 }
;
;
;
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;
;
;#include "StepMotor.h"
;#include "Sensor.h"
;#include "UART.h"
;#include "Algorithm.h"
;#include "LED.h"
;
;#define PI       3.14159265358979323846
;//TCNT const
;#define TCNT_REF 65385
;#define TCNT_LOW 65300
;
;#define TCNT_REF_FOR_RIGHT_TURN 65387
;#define TCNT_REF_FOR_LEFT_TURN 65377
;
;#define TCNT_TURN 65150
;#define TCNT_TURN_LEFT 65135
;
;//STEP const
;#define STEP_RIGHT 190
;#define STEP_LEFT 220
;
;//extern unsigned int MAP_COUNTER;
;
;// Declare your global variables here
;char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};

	.DSEG
;//R모터가 전진하기 위한 8step
;char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
;//L모터가 전진하기 위한 8step
;int LeftstepCount, RightstepCount; // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count
;unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3; // 왼쪽과 오른쪽 모터의 TCNT 속도
;unsigned char direction_control; // 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수
;//============================================ MAP
;unsigned int MAPP[500]={1};
;unsigned int counter_=0;
;
;// =====================================
;
;
;
;int L_motorspeed=0;
;int R_motorspeed=0;
;int sensor_value=0;
;
;//adjust
;int adjLeftSensor, adjRightSensor;
;int adjflagcnt = 0;
;
;unsigned int vel_counter_high_L, vel_counter_high_R, vel_counter_high = 65385;
;// Global variable for passing direction information to interrupt routine
;unsigned char direction_control;
;
;int ACCEL_CONTROL=0;
;eeprom extern unsigned int StandardSensor[3];
;eeprom extern unsigned int CenterStandardSensor[3];
;
;struct {
;int nStep4perBlock; // 한 블록 이동시 필요한 모터회전 스텝 정보
;int nStep4Turn90; // 90도 턴 이동시 필요한 모터회전 스텝 정보
;} Information;
;struct {
;char LmotorRun; // 왼쪽 모터가 회전했는지에 대한 Flag
;char RmotorRun; // 오른쪽 모터가 회전했는지에 대한 Flag
;} Flag;
;
;
;void Acceleration(int mode)
; 0002 0049 {

	.CSEG
; 0002 004A     int LStepCount = 0, RStepCount = 0;
; 0002 004B     TCCR1B = 0x04; //TIMER SET
;	mode -> Y+4
;	LStepCount -> R16,R17
;	RStepCount -> R18,R19
; 0002 004C     TCCR3B = 0x04;
; 0002 004D     direction_control = mode;
; 0002 004E     Flag.LmotorRun = FALSE;
; 0002 004F     Flag.RmotorRun = FALSE;
; 0002 0050 switch(mode)
; 0002 0051     {
; 0002 0052 
; 0002 0053     }
; 0002 0054 
; 0002 0055 
; 0002 0056 }
;
;
;
;
;
;void Direction(int mode)
; 0002 005D {
; 0002 005E     int LStepCount = 0, RStepCount = 0;
; 0002 005F     TCCR1B = 0x04; //TIMER SET
;	mode -> Y+4
;	LStepCount -> R16,R17
;	RStepCount -> R18,R19
; 0002 0060     TCCR3B = 0x04;
; 0002 0061     direction_control = mode;
; 0002 0062     Flag.LmotorRun = FALSE;
; 0002 0063     Flag.RmotorRun = FALSE;
; 0002 0064 switch(mode)
; 0002 0065     {
; 0002 0066     case ACCEL_HALF:  //ACCEL
; 0002 0067         {
; 0002 0068         //Information.nStep4perBlock = 1527step(int)
; 0002 0069         // TCNT_ref=65385; //모터의 속도 (65200 ~ 65535)  65400
; 0002 006A 
; 0002 006B         VelocityLeftmotorTCNT1 = TCNT_LOW; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 006C         VelocityRightmotorTCNT3 = TCNT_LOW; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 006D 
; 0002 006E 
; 0002 006F             while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
; 0002 0070             {
; 0002 0071                 if(VelocityLeftmotorTCNT1>=TCNT_REF || VelocityRightmotorTCNT3>=TCNT_REF )
; 0002 0072                 {
; 0002 0073                     VelocityLeftmotorTCNT1 = TCNT_REF;
; 0002 0074                     VelocityRightmotorTCNT3 = TCNT_REF;
; 0002 0075                 }
; 0002 0076                 if(Flag.LmotorRun)
; 0002 0077                 {
; 0002 0078                     LStepCount++;
; 0002 0079                     Flag.LmotorRun = FALSE;
; 0002 007A                 }
; 0002 007B                 if(Flag.RmotorRun)
; 0002 007C                 {
; 0002 007D                     RStepCount++;
; 0002 007E                     Flag.RmotorRun = FALSE;
; 0002 007F                 }
; 0002 0080                 if(ACCEL_CONTROL==1200)
; 0002 0081                 {
; 0002 0082                     ACCEL_CONTROL=0;
; 0002 0083                     VelocityLeftmotorTCNT1+=2;
; 0002 0084                     VelocityRightmotorTCNT3+=2;
; 0002 0085                 }
; 0002 0086                 ACCEL_CONTROL++;
; 0002 0087             }
; 0002 0088         }
; 0002 0089         ACCEL_CONTROL=0;
; 0002 008A         break;
; 0002 008B 
; 0002 008C         case DEACCEL_HALF:  //DEACCEL
; 0002 008D         {
; 0002 008E         //Information.nStep4perBlock=1527(int)
; 0002 008F         // TCNT_REF 65385 //모터의 속도 (65200 ~ 65535)  65400
; 0002 0090         //TCNT_LOW 65200
; 0002 0091 
; 0002 0092         VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 0093         VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 0094 
; 0002 0095 
; 0002 0096             while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
; 0002 0097             {
; 0002 0098                 if(VelocityLeftmotorTCNT1<=TCNT_LOW || VelocityRightmotorTCNT3<=TCNT_LOW )
; 0002 0099                 {
; 0002 009A                     VelocityLeftmotorTCNT1 = TCNT_LOW;
; 0002 009B                     VelocityRightmotorTCNT3 = TCNT_LOW;
; 0002 009C                 }
; 0002 009D                 if(Flag.LmotorRun)
; 0002 009E                 {
; 0002 009F                     LStepCount++;
; 0002 00A0                     Flag.LmotorRun = FALSE;
; 0002 00A1                 }
; 0002 00A2                 if(Flag.RmotorRun)
; 0002 00A3                 {
; 0002 00A4                     RStepCount++;
; 0002 00A5                     Flag.RmotorRun = FALSE;
; 0002 00A6                 }
; 0002 00A7                 if(ACCEL_CONTROL==1200)
; 0002 00A8                 {
; 0002 00A9                     ACCEL_CONTROL=0;
; 0002 00AA                     VelocityLeftmotorTCNT1-=1;
; 0002 00AB                     VelocityRightmotorTCNT3-=1;
; 0002 00AC                 }
; 0002 00AD                 ACCEL_CONTROL++;
; 0002 00AE             }
; 0002 00AF         }
; 0002 00B0         ACCEL_CONTROL=0;
; 0002 00B1         //VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 00B2         //VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 00B3 
; 0002 00B4         break;
; 0002 00B5 
; 0002 00B6         case DEACCEL_HALF_STOP:  //DEACCEL
; 0002 00B7         {
; 0002 00B8         //Information.nStep4perBlock=1527(int)
; 0002 00B9         // TCNT_REF 65385 //모터의 속도 (65200 ~ 65535)  65400
; 0002 00BA         //TCNT_LOW 65200
; 0002 00BB 
; 0002 00BC         VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 00BD         VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 00BE 
; 0002 00BF 
; 0002 00C0             while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
; 0002 00C1             {
; 0002 00C2                 if(Flag.LmotorRun)
; 0002 00C3                 {
; 0002 00C4                     LStepCount++;
; 0002 00C5                     Flag.LmotorRun = FALSE;
; 0002 00C6                 }
; 0002 00C7                 if(Flag.RmotorRun)
; 0002 00C8                 {
; 0002 00C9                     RStepCount++;
; 0002 00CA                     Flag.RmotorRun = FALSE;
; 0002 00CB                 }
; 0002 00CC                 if(ACCEL_CONTROL==1200)
; 0002 00CD                 {
; 0002 00CE                     ACCEL_CONTROL=0;
; 0002 00CF                     VelocityLeftmotorTCNT1-=1;
; 0002 00D0                     VelocityRightmotorTCNT3-=1;
; 0002 00D1                 }
; 0002 00D2                 ACCEL_CONTROL++;
; 0002 00D3             }
; 0002 00D4         }
; 0002 00D5         ACCEL_CONTROL=0;
; 0002 00D6         //VelocityLeftmotorTCNT1 = TCNT_REF; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 00D7         //VelocityRightmotorTCNT3 = TCNT_REF; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 00D8 
; 0002 00D9         break;
; 0002 00DA 
; 0002 00DB 
; 0002 00DC         /*
; 0002 00DD         case DEACCEL_WITH_HALF:  //DEACCEL
; 0002 00DE         {
; 0002 00DF 
; 0002 00E0         }
; 0002 00E1         break;
; 0002 00E2 
; 0002 00E3         case NOACCEL:  //NOACCEL
; 0002 00E4         {
; 0002 00E5 
; 0002 00E6         }
; 0002 00E7         break;
; 0002 00E8         */
; 0002 00E9 
; 0002 00EA 
; 0002 00EB 
; 0002 00EC     case ACCEL_HALF_START:  //ACCEL
; 0002 00ED         {
; 0002 00EE         //Information.nStep4perBlock=1527(int)
; 0002 00EF         // TCNT_ref=65385; //모터의 속도 (65200 ~ 65535)  65400
; 0002 00F0 
; 0002 00F1         VelocityLeftmotorTCNT1 = 65000; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 00F2         VelocityRightmotorTCNT3 = 65000; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 00F3 
; 0002 00F4 
; 0002 00F5             while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
; 0002 00F6             {
; 0002 00F7                 if(VelocityLeftmotorTCNT1>=TCNT_REF || VelocityRightmotorTCNT3>=TCNT_REF )
; 0002 00F8                 {
; 0002 00F9                     VelocityLeftmotorTCNT1 = TCNT_REF;
; 0002 00FA                     VelocityRightmotorTCNT3 = TCNT_REF;
; 0002 00FB                 }
; 0002 00FC                 if(Flag.LmotorRun)
; 0002 00FD                 {
; 0002 00FE                     LStepCount++;
; 0002 00FF                     Flag.LmotorRun = FALSE;
; 0002 0100                 }
; 0002 0101                 if(Flag.RmotorRun)
; 0002 0102                 {
; 0002 0103                     RStepCount++;
; 0002 0104                     Flag.RmotorRun = FALSE;
; 0002 0105                 }
; 0002 0106 
; 0002 0107                      if(ACCEL_CONTROL==600)
; 0002 0108                 {
; 0002 0109                     ACCEL_CONTROL=0;
; 0002 010A                     VelocityLeftmotorTCNT1+=2;
; 0002 010B                     VelocityRightmotorTCNT3+=2;
; 0002 010C                 }
; 0002 010D                 ACCEL_CONTROL++;
; 0002 010E 
; 0002 010F 
; 0002 0110             }
; 0002 0111         }
; 0002 0112         ACCEL_CONTROL=0;
; 0002 0113 
; 0002 0114         break;
; 0002 0115 
; 0002 0116     case TURN_RIGHT:   //RIGHT
; 0002 0117 
; 0002 0118     MAPP[counter_]=TURN_RIGHT;
; 0002 0119     counter_++;
; 0002 011A     VelocityLeftmotorTCNT1 = TCNT_REF_FOR_RIGHT_TURN+10; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 011B     VelocityRightmotorTCNT3 = TCNT_TURN+45; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 011C     while(LStepCount<(STEP_RIGHT) || RStepCount<(STEP_RIGHT))
; 0002 011D     {
; 0002 011E     //Information.nStep4perBlock
; 0002 011F 
; 0002 0120         if(Flag.LmotorRun)
; 0002 0121         {
; 0002 0122             LStepCount++;
; 0002 0123             Flag.LmotorRun = FALSE;
; 0002 0124         }
; 0002 0125         if(Flag.RmotorRun)
; 0002 0126         {
; 0002 0127             RStepCount++;
; 0002 0128             Flag.RmotorRun = FALSE;
; 0002 0129         }
; 0002 012A     }
; 0002 012B     break;
; 0002 012C 
; 0002 012D 
; 0002 012E 
; 0002 012F     case TURN_LEFT:   //LEFT
; 0002 0130 
; 0002 0131     MAPP[counter_]=TURN_LEFT;
; 0002 0132     counter_++;
; 0002 0133     VelocityLeftmotorTCNT1 =TCNT_TURN_LEFT ; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
; 0002 0134     VelocityRightmotorTCNT3 = TCNT_REF_FOR_LEFT_TURN; // 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 0135     while(LStepCount<(STEP_LEFT) || RStepCount<(STEP_LEFT))
; 0002 0136     {
; 0002 0137 
; 0002 0138         if(Flag.LmotorRun)
; 0002 0139         {
; 0002 013A             LStepCount++;
; 0002 013B             Flag.LmotorRun = FALSE;
; 0002 013C         }
; 0002 013D         if(Flag.RmotorRun)
; 0002 013E         {
; 0002 013F             RStepCount++;
; 0002 0140             Flag.RmotorRun = FALSE;
; 0002 0141         }
; 0002 0142     }
; 0002 0143     break;
; 0002 0144 
; 0002 0145 
; 0002 0146     case FORWARD:  //FORWARD
; 0002 0147     while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
; 0002 0148     {
; 0002 0149     adjustmouse();
; 0002 014A     if(Flag.LmotorRun)
; 0002 014B     {
; 0002 014C         LStepCount++;
; 0002 014D         Flag.LmotorRun = FALSE;
; 0002 014E     }
; 0002 014F     if(Flag.RmotorRun)
; 0002 0150     {
; 0002 0151         RStepCount++;
; 0002 0152         Flag.RmotorRun = FALSE;
; 0002 0153     }
; 0002 0154     }
; 0002 0155     break;
; 0002 0156 
; 0002 0157 
; 0002 0158 
; 0002 0159     case HALF:        //HALF
; 0002 015A     LED_ON(LED4);
; 0002 015B     while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
; 0002 015C     {
; 0002 015D 
; 0002 015E     adjustmouse();
; 0002 015F 
; 0002 0160     //UART
; 0002 0161 
; 0002 0162     if(Flag.LmotorRun)
; 0002 0163     {
; 0002 0164         LStepCount++;
; 0002 0165         Flag.LmotorRun = FALSE;
; 0002 0166     }
; 0002 0167     if(Flag.RmotorRun)
; 0002 0168     {
; 0002 0169         RStepCount++;
; 0002 016A         Flag.RmotorRun = FALSE;
; 0002 016B     }
; 0002 016C     }
; 0002 016D     break;
; 0002 016E 
; 0002 016F     case HALF_HALF:        //HALF
; 0002 0170     LED_ON(LED4);
; 0002 0171     while(LStepCount<(Information.nStep4perBlock>>2) || RStepCount<(Information.nStep4perBlock>>2))
; 0002 0172     {
; 0002 0173 
; 0002 0174     adjustmouse();
; 0002 0175 
; 0002 0176     //UART
; 0002 0177 
; 0002 0178     if(Flag.LmotorRun)
; 0002 0179     {
; 0002 017A         LStepCount++;
; 0002 017B         Flag.LmotorRun = FALSE;
; 0002 017C     }
; 0002 017D     if(Flag.RmotorRun)
; 0002 017E     {
; 0002 017F         RStepCount++;
; 0002 0180         Flag.RmotorRun = FALSE;
; 0002 0181     }
; 0002 0182     }
; 0002 0183     break;
; 0002 0184 
; 0002 0185     case HALF_HALF_HALF:
; 0002 0186     LED_ON(LED4);
; 0002 0187 
; 0002 0188     MAPP[counter_]=HALF_HALF_HALF;
; 0002 0189     counter_++;
; 0002 018A 
; 0002 018B     while(LStepCount<(Information.nStep4perBlock>>3) || RStepCount<(Information.nStep4perBlock>>3))
; 0002 018C     {
; 0002 018D 
; 0002 018E     adjustmouse();
; 0002 018F 
; 0002 0190     //UART
; 0002 0191 
; 0002 0192     if(Flag.LmotorRun)
; 0002 0193     {
; 0002 0194         LStepCount++;
; 0002 0195         Flag.LmotorRun = FALSE;
; 0002 0196     }
; 0002 0197     if(Flag.RmotorRun)
; 0002 0198     {
; 0002 0199         RStepCount++;
; 0002 019A         Flag.RmotorRun = FALSE;
; 0002 019B     }
; 0002 019C     }
; 0002 019D     break;
; 0002 019E 
; 0002 019F 
; 0002 01A0     case LEFT:    //LEFT
; 0002 01A1     case RIGHT:   //RIGHT
; 0002 01A2     MAPP[counter_]=0;
; 0002 01A3     counter_++;
; 0002 01A4     while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
; 0002 01A5     {
; 0002 01A6     if(Flag.LmotorRun)
; 0002 01A7     {
; 0002 01A8         LStepCount++;
; 0002 01A9         Flag.LmotorRun = FALSE;
; 0002 01AA     }
; 0002 01AB     if(Flag.RmotorRun)
; 0002 01AC     {
; 0002 01AD         RStepCount++;
; 0002 01AE         Flag.RmotorRun = FALSE;
; 0002 01AF     }
; 0002 01B0     }
; 0002 01B1     break;
; 0002 01B2 
; 0002 01B3 
; 0002 01B4 
; 0002 01B5     case BACK:    //BACK
; 0002 01B6     while(LStepCount<(Information.nStep4Turn90*2) || RStepCount<(Information.nStep4Turn90*2))
; 0002 01B7     {
; 0002 01B8     if(Flag.LmotorRun)
; 0002 01B9     {
; 0002 01BA         LStepCount++;
; 0002 01BB         Flag.LmotorRun = FALSE;
; 0002 01BC     }
; 0002 01BD     if(Flag.RmotorRun)
; 0002 01BE     {
; 0002 01BF         RStepCount++;
; 0002 01C0         Flag.RmotorRun = FALSE;
; 0002 01C1     }
; 0002 01C2     }
; 0002 01C3         break;
; 0002 01C4     }
; 0002 01C5     TCCR1B = 0x00;
; 0002 01C6     TCCR3B = 0x00;
; 0002 01C7 }
;
;void adjustmouse(void){				//직진 보정 알고리즘
; 0002 01C9 void adjustmouse(void){
; 0002 01CA 
; 0002 01CB     vel_counter_high=65385;
; 0002 01CC     adjLeftSensor = readSensor(LEFT_SENSOR); 		//왼쪽 센서값 읽어서 adjleft에 저장
; 0002 01CD     adjRightSensor = readSensor(RIGHT_SENSOR);	//우측 센서값 읽어서 adjright에 저장
; 0002 01CE     //printf("adj_left:%d  adj_right:%d   \ncenter_standard_left:%d     center_standard_left:%d\n",adjLeftSensor,adjRightSensor,StandardSensor[1],StandardSensor[2]);
; 0002 01CF 
; 0002 01D0    /* vel_counter_high_L = VelocityLeftmotorTCNT1;	//현재 바퀴속도값을 변수 counter에 각각 저장(65200 ~ 65535)
; 0002 01D1     vel_counter_high_R = VelocityRightmotorTCNT3;  */
; 0002 01D2 
; 0002 01D3     // If none of the left and right walls are present
; 0002 01D4     if((adjRightSensor-27<StandardSensor[2]) || (adjLeftSensor-10<StandardSensor[0]))
; 0002 01D5     {	//좌우 벽중 하나가 없을 시 무조건 등속( 반대로 얘기하면 양쪽에 벽이 있어야만 좌우보정 start)
; 0002 01D6 
; 0002 01D7         vel_counter_high_L = vel_counter_high;  // Equal velocity
; 0002 01D8         vel_counter_high_R = vel_counter_high;
; 0002 01D9     }
; 0002 01DA     else{							//좌우 벽둘다 존재 할 경우 보정 시작
; 0002 01DB         // If the right wall is far
; 0002 01DC         if(adjRightSensor-27 < CenterStandardSensor[2]){		//우측 벽이 더멀면  => 정중앙보다 왼쪽에 있다
; 0002 01DD         //LED_ON(LED4);///////////////////////////////////////
; 0002 01DE        /* printf("%d  \t%d \t %d \t %d\r\n",adjRightSensor,readSensor(RIGHT_SENSOR),CenterStandardSensor[0],CenterStandardSensor[2]);
; 0002 01DF               delay_ms(1000);*/
; 0002 01E0 
; 0002 01E1 
; 0002 01E2 
; 0002 01E3             vel_counter_high_L+=1;				//좌측 속도 높이고
; 0002 01E4             vel_counter_high_R-=1;				//우측 속도 down	1의 값을 높이면 변하는 tempo를 더 빠르게 할 수 있음
; 0002 01E5             if(vel_counter_high_L > vel_counter_high+20){		//속도 변화량의 최대값 설정 아무리 높아도 +20정도까지만 되게
; 0002 01E6                 vel_counter_high_L = vel_counter_high+20;
; 0002 01E7             }
; 0002 01E8             if(vel_counter_high_R < (vel_counter_high-20)){
; 0002 01E9                 vel_counter_high_R = (vel_counter_high-20);
; 0002 01EA             }
; 0002 01EB         }else{
; 0002 01EC             adjflagcnt++;					//카운트 1증가
; 0002 01ED         }
; 0002 01EE         // If the left wall is far
; 0002 01EF         if(adjLeftSensor-10 < CenterStandardSensor[0]){		//좌측벽도 마찬가지로 진행
; 0002 01F0             vel_counter_high_L-=1;
; 0002 01F1             vel_counter_high_R+=1;
; 0002 01F2             if(vel_counter_high_R > vel_counter_high+20){
; 0002 01F3                 vel_counter_high_R = vel_counter_high+20;
; 0002 01F4             }
; 0002 01F5             if(vel_counter_high_L < (vel_counter_high-20)){
; 0002 01F6                 vel_counter_high_L = (vel_counter_high-20);
; 0002 01F7             }
; 0002 01F8         }else{
; 0002 01F9             adjflagcnt++;					//카운트 1중가
; 0002 01FA         }
; 0002 01FB         // If both left and right walls are not far away
; 0002 01FC         if(adjflagcnt==2){					//둘다 보정 후에 값 입력
; 0002 01FD             vel_counter_high_L = vel_counter_high;  // Equal velocity
; 0002 01FE             vel_counter_high_R = vel_counter_high;
; 0002 01FF         }
; 0002 0200     }
; 0002 0201     VelocityLeftmotorTCNT1 = vel_counter_high_L;
; 0002 0202     VelocityRightmotorTCNT3 = vel_counter_high_R;
; 0002 0203 
; 0002 0204 }
;
;
;
;
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0002 020C {
_timer1_ovf_isr:
	CALL SUBOPT_0x4
; 0002 020D // Place your code here
; 0002 020E switch(direction_control)
; 0002 020F {
; 0002 0210     case LEFT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4008C
; 0002 0211     PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x5
	OR   R30,R26
	OUT  0x12,R30
; 0002 0212     PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0002 0213     LeftstepCount--;
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0002 0214     if(LeftstepCount < 0)
	LDS  R26,_LeftstepCount+1
	TST  R26
	BRPL _0x4008D
; 0002 0215     LeftstepCount = sizeof(rotateL)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _LeftstepCount,R30
	STS  _LeftstepCount+1,R31
; 0002 0216     break;
_0x4008D:
	RJMP _0x4008B
; 0002 0217 
; 0002 0218     case RIGHT:
_0x4008C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x4008F
; 0002 0219     case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x40090
_0x4008F:
; 0002 021A     case FORWARD:
	RJMP _0x40091
_0x40090:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x40092
_0x40091:
; 0002 021B     case HALF:
	RJMP _0x40093
_0x40092:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x40094
_0x40093:
; 0002 021C     case ACCEL_HALF:
	RJMP _0x40095
_0x40094:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x40096
_0x40095:
; 0002 021D     case DEACCEL_HALF:
	RJMP _0x40097
_0x40096:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x40098
_0x40097:
; 0002 021E     case DEACCEL_HALF_STOP:  //DEACCEL
	RJMP _0x40099
_0x40098:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x4009A
_0x40099:
; 0002 021F     case ACCEL_HALF_START:
	RJMP _0x4009B
_0x4009A:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4009C
_0x4009B:
; 0002 0220     case TURN_RIGHT:   //RIGHT
	RJMP _0x4009D
_0x4009C:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x4009E
_0x4009D:
; 0002 0221     case TURN_LEFT:
	RJMP _0x4009F
_0x4009E:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x400A0
_0x4009F:
; 0002 0222     case HALF_HALF:
	RJMP _0x400A1
_0x400A0:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x400A2
_0x400A1:
; 0002 0223     case HALF_HALF_HALF:
	RJMP _0x400A3
_0x400A2:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x4008B
_0x400A3:
; 0002 0224     PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x5
	OR   R30,R26
	OUT  0x12,R30
; 0002 0225     PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0002 0226     LeftstepCount++;
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0002 0227     LeftstepCount %= sizeof(rotateL);
	LDS  R26,_LeftstepCount
	LDS  R27,_LeftstepCount+1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	STS  _LeftstepCount,R30
	STS  _LeftstepCount+1,R31
; 0002 0228     break;
; 0002 0229 }
_0x4008B:
; 0002 022A 
; 0002 022B Flag.LmotorRun = TRUE;
	LDI  R30,LOW(1)
	STS  _Flag,R30
; 0002 022C TCNT1H = VelocityLeftmotorTCNT1 >> 8;
	LDS  R30,_VelocityLeftmotorTCNT1+1
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0002 022D TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
	LDS  R30,_VelocityLeftmotorTCNT1
	OUT  0x2C,R30
; 0002 022E }
	RJMP _0x400C2
;
;
;
;
;// Timer 3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0002 0235 {
_timer3_ovf_isr:
	CALL SUBOPT_0x4
; 0002 0236 // Place your code here
; 0002 0237 switch(direction_control)
; 0002 0238 {
; 0002 0239 case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x400A9
; 0002 023A case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x400AA
_0x400A9:
; 0002 023B PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x7
	OR   R30,R26
	OUT  0x3,R30
; 0002 023C PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0002 023D RightstepCount--;
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0002 023E if(RightstepCount < 0)
	LDS  R26,_RightstepCount+1
	TST  R26
	BRPL _0x400AB
; 0002 023F RightstepCount = sizeof(rotateR)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _RightstepCount,R30
	STS  _RightstepCount+1,R31
; 0002 0240 break;
_0x400AB:
	RJMP _0x400A7
; 0002 0241 case FORWARD:
_0x400AA:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x400AD
; 0002 0242 case HALF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x400AE
_0x400AD:
; 0002 0243 case LEFT:
	RJMP _0x400AF
_0x400AE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x400B0
_0x400AF:
; 0002 0244 case ACCEL_HALF:
	RJMP _0x400B1
_0x400B0:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x400B2
_0x400B1:
; 0002 0245 case DEACCEL_HALF:
	RJMP _0x400B3
_0x400B2:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x400B4
_0x400B3:
; 0002 0246 case DEACCEL_HALF_STOP:  //DEACCEL
	RJMP _0x400B5
_0x400B4:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x400B6
_0x400B5:
; 0002 0247 case ACCEL_HALF_START:
	RJMP _0x400B7
_0x400B6:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x400B8
_0x400B7:
; 0002 0248 case TURN_RIGHT:
	RJMP _0x400B9
_0x400B8:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x400BA
_0x400B9:
; 0002 0249 case TURN_LEFT:
	RJMP _0x400BB
_0x400BA:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x400BC
_0x400BB:
; 0002 024A case HALF_HALF:
	RJMP _0x400BD
_0x400BC:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x400BE
_0x400BD:
; 0002 024B case HALF_HALF_HALF:
	RJMP _0x400BF
_0x400BE:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x400A7
_0x400BF:
; 0002 024C PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x7
	OR   R30,R26
	OUT  0x3,R30
; 0002 024D PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0002 024E RightstepCount++;
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0002 024F RightstepCount %= sizeof(rotateR);
	LDS  R26,_RightstepCount
	LDS  R27,_RightstepCount+1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	STS  _RightstepCount,R30
	STS  _RightstepCount+1,R31
; 0002 0250 break;
; 0002 0251 }
_0x400A7:
; 0002 0252 Flag.RmotorRun = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Flag,1
; 0002 0253 TCNT3H = VelocityRightmotorTCNT3 >> 8;
	LDS  R30,_VelocityRightmotorTCNT3+1
	STS  137,R30
; 0002 0254 TCNT3L = VelocityRightmotorTCNT3 & 0xff;
	LDS  R30,_VelocityRightmotorTCNT3
	STS  136,R30
; 0002 0255 }
_0x400C2:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;
;
;
;void InitializeStepMotor(void)
; 0002 025C {
_InitializeStepMotor:
; 0002 025D double distance4perStep;
; 0002 025E 
; 0002 025F // LEFT MOTOR - PORTD 4,5,6,7
; 0002 0260 PORTD&=0x0F;
	SBIW R28,4
;	distance4perStep -> Y+0
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0002 0261 DDRD|=0xF0;
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
; 0002 0262 // RIGHT MOTOR - PORTE 4,5,6,7
; 0002 0263 PORTE&=0x0F;
	IN   R30,0x3
	ANDI R30,LOW(0xF)
	OUT  0x3,R30
; 0002 0264 DDRE|=0xF0;
	IN   R30,0x2
	ORI  R30,LOW(0xF0)
	OUT  0x2,R30
; 0002 0265 // Timer/Counter 1 initialization
; 0002 0266 // Clock source: System Clock
; 0002 0267 // Clock value: 62.500 kHz
; 0002 0268 // Mode: Normal top=FFFFh
; 0002 0269 // OC1A output: Discon.
; 0002 026A // OC1B output: Discon.
; 0002 026B // OC1C output: Discon.
; 0002 026C // Noise Canceler: Off
; 0002 026D // Input Capture on Falling Edge
; 0002 026E // Timer 1 Overflow Interrupt: On
; 0002 026F // Input Capture Interrupt: Off
; 0002 0270 // Compare A Match Interrupt: Off
; 0002 0271 // Compare B Match Interrupt: Off
; 0002 0272 // Compare C Match Interrupt: Off
; 0002 0273 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0002 0274 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0002 0275 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0002 0276 TCNT1L=0x00;
	OUT  0x2C,R30
; 0002 0277 ICR1H=0x00;
	OUT  0x27,R30
; 0002 0278 ICR1L=0x00;
	OUT  0x26,R30
; 0002 0279 OCR1AH=0x00;
	OUT  0x2B,R30
; 0002 027A OCR1AL=0x00;
	OUT  0x2A,R30
; 0002 027B OCR1BH=0x00;
	OUT  0x29,R30
; 0002 027C OCR1BL=0x00;
	OUT  0x28,R30
; 0002 027D OCR1CH=0x00;
	STS  121,R30
; 0002 027E OCR1CL=0x00;
	STS  120,R30
; 0002 027F // Timer/Counter 3 initialization
; 0002 0280 // Clock source: System Clock
; 0002 0281 // Clock value: 62.500 kHz
; 0002 0282 // Mode: Normal top=FFFFh
; 0002 0283 // OC3A output: Discon.
; 0002 0284 // OC3B output: Discon.
; 0002 0285 // OC3C output: Discon.
; 0002 0286 // Noise Canceler: Off
; 0002 0287 // Input Capture on Falling Edge
; 0002 0288 // Timer 3 Overflow Interrupt: On
; 0002 0289 // Input Capture Interrupt: Off
; 0002 028A // Compare A Match Interrupt: Off
; 0002 028B // Compare B Match Interrupt: Off
; 0002 028C // Compare C Match Interrupt: Off
; 0002 028D TCCR3A=0x00;
	STS  139,R30
; 0002 028E TCCR3B=0x04;
	LDI  R30,LOW(4)
	STS  138,R30
; 0002 028F TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0002 0290 TCNT3L=0x00;
	STS  136,R30
; 0002 0291 ICR3H=0x00;
	STS  129,R30
; 0002 0292 ICR3L=0x00;
	STS  128,R30
; 0002 0293 OCR3AH=0x00;
	STS  135,R30
; 0002 0294 OCR3AL=0x00;
	STS  134,R30
; 0002 0295 OCR3BH=0x00;
	STS  133,R30
; 0002 0296 OCR3BL=0x00;
	STS  132,R30
; 0002 0297 OCR3CH=0x00;
	STS  131,R30
; 0002 0298 OCR3CL=0x00;
	STS  130,R30
; 0002 0299 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0002 029A TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0002 029B ETIMSK=0x04;
	STS  125,R30
; 0002 029C 
; 0002 029D 
; 0002 029E distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	__GETD1N 0x3ECD154B
	CALL __PUTD1S0
; 0002 029F //0.1178(mm)
; 0002 02A0 Information.nStep4perBlock = (int)((double)180. / distance4perStep);
	__GETD2N 0x43340000
	CALL __DIVF21
	CALL __CFD1
	STS  _Information,R30
	STS  _Information+1,R31
; 0002 02A1 //1527.88(step)
; 0002 02A2 Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);
	CALL __GETD1S0
	__GETD2N 0x4280CE28
	CALL __DIVF21
	CALL __CFD1
	__PUTW1MN _Information,2
; 0002 02A3 
; 0002 02A4 //Information.nStep4Turn90_RIGHT_WHEEL = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);
; 0002 02A5 //Information.nStep4Turn90_LEFT_WHEEL = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);
; 0002 02A6 
; 0002 02A7 //====================
; 0002 02A8 LeftstepCount=0;
	LDI  R30,LOW(0)
	STS  _LeftstepCount,R30
	STS  _LeftstepCount+1,R30
; 0002 02A9 RightstepCount=0;
	STS  _RightstepCount,R30
	STS  _RightstepCount+1,R30
; 0002 02AA 
; 0002 02AB #asm("sei")
	sei
; 0002 02AC VelocityLeftmotorTCNT1 = 65385; // 왼쪽 모터의 속도 (65200 ~ 65535)  65400
	LDI  R30,LOW(65385)
	LDI  R31,HIGH(65385)
	STS  _VelocityLeftmotorTCNT1,R30
	STS  _VelocityLeftmotorTCNT1+1,R31
; 0002 02AD VelocityRightmotorTCNT3 = 65385; // 오른쪽 모터의 속도 (65200 ~ 65535)
	STS  _VelocityRightmotorTCNT3,R30
	STS  _VelocityRightmotorTCNT3+1,R31
; 0002 02AE //====================
; 0002 02AF 
; 0002 02B0 }
	ADIW R28,4
	RET
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "LED.h"
;// LED1:0x10 2:0x20 3:0x40 4:0x80   //가 꺼지는거
;
;
;void IO_init(void)//LED init
; 0003 0008 {

	.CSEG
_IO_init:
; 0003 0009 // LED - PORTF 4,5,6,7
; 0003 000A     PORTF &= 0x0F;
	LDS  R30,98
	ANDI R30,LOW(0xF)
	STS  98,R30
; 0003 000B     DDRF |= 0xF0;
	LDS  R30,97
	ORI  R30,LOW(0xF0)
	STS  97,R30
; 0003 000C }
	RET
;
;// LED1 -> LED2 (=LED1*2)
;void LED_ON(int nLED)//LED_ON(LED2);
; 0003 0010 {
_LED_ON:
; 0003 0011     PORTF &= ~(nLED);
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R26,X
	LD   R30,Y
	COM  R30
	AND  R30,R26
	RJMP _0x20A0002
; 0003 0012 }
;
;void LED_OFF(int nLED)//LED OFF
; 0003 0015 {
_LED_OFF:
; 0003 0016     PORTF |= nLED;
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R30,X
	LD   R26,Y
	OR   R30,R26
_0x20A0002:
	MOV  R26,R0
	ST   X,R30
; 0003 0017 }
	ADIW R28,2
	RET
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include "switch.h"
;#include "LED.h"
;
;// Declare your global variables here
;    struct Buttons{
;        char SW1;
;        char SW2;
;}Button;
;//Buttons Button;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0004 000F {

	.CSEG
_ext_int0_isr:
	ST   -Y,R30
; 0004 0010     // Place your code here
; 0004 0011     Button.SW1 = TRUE;
	LDI  R30,LOW(1)
	STS  _Button,R30
; 0004 0012 
; 0004 0013 }
	RJMP _0x80003
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0004 0017 {
_ext_int1_isr:
	ST   -Y,R30
; 0004 0018     // Place your code here
; 0004 0019     Button.SW2 = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Button,1
; 0004 001A 
; 0004 001B }
_0x80003:
	LD   R30,Y+
	RETI
;
;
;char SW1(void)
; 0004 001F {
_SW1:
; 0004 0020 char ret;
; 0004 0021 ret = Button.SW1;
	ST   -Y,R17
;	ret -> R17
	LDS  R17,_Button
; 0004 0022 Button.SW1 = FALSE;
	LDI  R30,LOW(0)
	STS  _Button,R30
; 0004 0023 return ret;
	RJMP _0x20A0001
; 0004 0024 }
;
;char SW2(void)
; 0004 0027 {
_SW2:
; 0004 0028 char ret;
; 0004 0029 ret = Button.SW2;
	ST   -Y,R17
;	ret -> R17
	__GETBRMN 17,_Button,1
; 0004 002A Button.SW2 = FALSE;
	LDI  R30,LOW(0)
	__PUTB1MN _Button,1
; 0004 002B return ret;
_0x20A0001:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0004 002C }
;
;
;
;
;void InitializeSwitch(void)
; 0004 0032 {
_InitializeSwitch:
; 0004 0033 // 스위치 PORTD 0,1
; 0004 0034 PORTD &= 0xfc;
	IN   R30,0x12
	ANDI R30,LOW(0xFC)
	OUT  0x12,R30
; 0004 0035 DDRD &= 0xfc;
	IN   R30,0x11
	ANDI R30,LOW(0xFC)
	OUT  0x11,R30
; 0004 0036 // External Interrupt(s) initialization
; 0004 0037 // INT0: On
; 0004 0038 // INT0 Mode: Falling Edge
; 0004 0039 // INT1: On
; 0004 003A // INT1 Mode: Falling Edge
; 0004 003B // INT2: Off
; 0004 003C // INT3: Off
; 0004 003D // INT4: Off
; 0004 003E // INT5: Off
; 0004 003F // INT6: Off
; 0004 0040 // INT7: Off
; 0004 0041 EICRA=0x0A;
	LDI  R30,LOW(10)
	STS  106,R30
; 0004 0042 EICRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0004 0043 EIMSK=0x03;
	LDI  R30,LOW(3)
	OUT  0x39,R30
; 0004 0044 EIFR=0x03;
	OUT  0x38,R30
; 0004 0045 }
	RET
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "UART.h"
;
;// Write a character to the USART1 Transmitter
;void putchar(char c){
; 0005 0005 void putchar(char c){

	.CSEG
_putchar:
; 0005 0006     while((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
_0xA0003:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0xA0003
; 0005 0007     UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0005 0008 }
	ADIW R28,1
	RET
;
;// Read a character from the USART1 Receiver
;
;
;
;unsigned char getchar(void){
; 0005 000E unsigned char getchar(void){
; 0005 000F     while((UCSR1A & RX_COMPLETE)==0);
; 0005 0010     return UDR1;
; 0005 0011 }
;
;
;
;void InitializeUART(void){
; 0005 0015 void InitializeUART(void){
_InitializeUART:
; 0005 0016     // USART1 initialization
; 0005 0017     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0005 0018     // USART1 Receiver: On
; 0005 0019     // USART1 Transmitter: On
; 0005 001A     // USART1 Mode: Asynchronous
; 0005 001B     // USART1 Baud Rate: 9600
; 0005 001C     UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0005 001D     UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0005 001E     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0005 001F     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0005 0020     UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0005 0021 }
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x9
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x9
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0xA
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xB
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x9
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x9
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x9
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xB
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_VelocityLeftmotorTCNT1:
	.BYTE 0x2
_VelocityRightmotorTCNT3:
	.BYTE 0x2
_adjLeftSensor:
	.BYTE 0x2
_adjRightSensor:
	.BYTE 0x2
_MAPP:
	.BYTE 0x3E8
_counter_:
	.BYTE 0x2

	.ESEG
_CANCEL_FLAG:
	.DW  0x0
_StandardSensor:
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DW  0x0
_CenterStandardSensor:
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DW  0x0
_MAP:
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x1000F),HIGH(0x1000F),BYTE3(0x1000F),BYTE4(0x1000F)
	.DB  LOW(0x10001),HIGH(0x10001),BYTE3(0x10001),BYTE4(0x10001)
	.DB  LOW(0xF0001),HIGH(0xF0001),BYTE3(0xF0001),BYTE4(0xF0001)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0xF0010),HIGH(0xF0010),BYTE3(0xF0010),BYTE4(0xF0010)
	.DB  LOW(0x10001),HIGH(0x10001),BYTE3(0x10001),BYTE4(0x10001)
	.DB  LOW(0x10001),HIGH(0x10001),BYTE3(0x10001),BYTE4(0x10001)
	.DB  LOW(0x10000F),HIGH(0x10000F),BYTE3(0x10000F),BYTE4(0x10000F)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x100010),HIGH(0x100010),BYTE3(0x100010),BYTE4(0x100010)
	.DB  LOW(0x630000),HIGH(0x630000),BYTE3(0x630000),BYTE4(0x630000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
_MAP_COUNTER:
	.DW  0x0

	.DSEG
_rotateR:
	.BYTE 0x8
_rotateL:
	.BYTE 0x8
_LeftstepCount:
	.BYTE 0x2
_RightstepCount:
	.BYTE 0x2
_direction_control:
	.BYTE 0x1
_adjflagcnt:
	.BYTE 0x2
_vel_counter_high_L:
	.BYTE 0x2
_vel_counter_high_R:
	.BYTE 0x2
_vel_counter_high:
	.BYTE 0x2
_ACCEL_CONTROL:
	.BYTE 0x2
_Information:
	.BYTE 0x4
_Flag:
	.BYTE 0x2
_Button:
	.BYTE 0x2
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1:
	MOVW R30,R10
	LDI  R26,LOW(_MAP)
	LDI  R27,HIGH(_MAP)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	__POINTW1FN _0x0,27
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0x0,23
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_direction_control
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x5:
	IN   R30,0x12
	MOV  R26,R30
	LDS  R30,_LeftstepCount
	LDS  R31,_LeftstepCount+1
	SUBI R30,LOW(-_rotateL)
	SBCI R31,HIGH(-_rotateL)
	LD   R30,Z
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	SUBI R30,-LOW(15)
	AND  R30,R26
	OUT  0x12,R30
	LDI  R26,LOW(_LeftstepCount)
	LDI  R27,HIGH(_LeftstepCount)
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x7:
	IN   R30,0x3
	MOV  R26,R30
	LDS  R30,_RightstepCount
	LDS  R31,_RightstepCount+1
	SUBI R30,LOW(-_rotateR)
	SBCI R31,HIGH(-_rotateR)
	LD   R30,Z
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	SUBI R30,-LOW(15)
	AND  R30,R26
	OUT  0x3,R30
	LDI  R26,LOW(_RightstepCount)
	LDI  R27,HIGH(_RightstepCount)
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x9:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
