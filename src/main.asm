@.CharSet=CP1251
@GNU AS

.syntax unified     @ ��������� ��������� ����
.thumb              @ ��� ������������ ���������� Thumb
.cpu cortex-m3      @ ���������
.include "/src/inc/st7789v.inc"
.include "/src/inc/gpio.inc"
.section .asmcode
@ �������� ���������
.global Start
Start:
     @MOVW r0, #:lower16:BSS_END_ADDRESS
     @MOVT r0, #:upper16:BSS_END_ADDRESS
     EOR r11,r11
     MOV r12, #1
     LDR r0, =_BSS_START
     LDR r1, =_BSS_END
     EOR r2,r2
BBS_CLEAR_LOOP:
     CMP r0, r1
     BEQ BSS_REGION_END
     STR r2, [r0], #4
     B BBS_CLEAR_LOOP

BSS_REGION_END:
     BL SYSCLK72         @ �������� ������������ �� �������� ������ �� 72���
     BL SYSTICK_INIT     @ ��������� ���������� �������
     LDR r0, =(CLOCK_AFIO|CLOCK_GPIOA|CLOCK_GPIOB)
     BL GPIO_ClockON
     BL SPI1_Init        @ �������� SPI1
     BL LCD_Init         @ ��������� �������

MAIN_LOOP:

B MAIN_LOOP



