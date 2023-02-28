@.CHARSET CP1251

@ GNU AS
.syntax unified
.cpu cortex-m3
.thumb

@.DESC name=SYSCLK72 type=proc
@ +------------------------------------------------------------+
@ |               ������ ��������� ������������                |
@ |                                                            |
@ |
@ +------------------------------------------------------------+
@ | ���������������: STM32F103xxx                              |
@ +------------------------------------------------------------+
@ | ������ ����������� ������������ ����������������           |
@ | �� ������� ��������� ��������� HSE � �������� 8 ���        |
@ | � ���������� ������� ��� ������ ����� PLL �� 9 �� 72 ���   |
@ +------------------------------------------------------------+
@ | LATENCY = 2 ����� �������� �� RM                           |
@ | ���� �������� CSS ������ HSE �� �������������              |
@ | ������������ USB �������������� � ��������� ��������� 1.5  |
@ | �� PLLCLK (72 ���) RCC_CFGR_USBPRE=0
@ +------------------------------------------------------------+
@ | ��������� �� ��������� ������: https://youtu.be/Qtu_V-fOAjY|
@ | ArmAsmEditor: STM32 �� ����������:  ��������� ������������ |
@ | ���������������� �� 24 ���. ����� 11                       |
@ +------------------------------------------------------------+
@.ENDDESC

.INCLUDE  "/src/inc/rcc.inc"
.INCLUDE  "/src/inc/flash.inc"


.GLOBAL   SYSCLK72
SYSCLK72:
                    PUSH {r0-r6,lr}
                    MOV        R1, 1
                    MOV        R0, 0
                    LDR        R2, = PERIPH_BASE + PERIPH_BB_BASE + ( RCC_BASE + RCC_CR ) * 32    @ RCC_CR �� �������
                    STR        R1, [ R2, RCC_CR_HSEON_N * 4 ]    @ �������� ��� HSE_ON � �������� RCC_CR (���-������)
label1:             LDR        R3, [ R2, RCC_CR_HSERDY_N * 4 ]    @ ������ HSE_RDY (���-������)
                    CMP        R3, 1
                    BNE        label1               @ ��������� ���������� HSE
                     @ HSE ��������

                     @ ��������� ���������� PLL
                    LDR        R4, = RCC + RCC_CFGR    @ RCC_CFGR ������ ������ � ��������
                    LDR        R5, = RCC_CFGR_PLLSRC + RCC_CFGR_PLLMUL9 + RCC_CFGR_PPRE1_DIV2
                    STR        R5, [ R4, 0 ]        @ �������� RCC_CFGR
                    STR        R1, [ R2, RCC_CR_PLLON_N * 4 ]    @ �������� ��� PLL_ON � �������� RCC_CR (���-������)
label2:             LDR        R3, [ R2, RCC_CR_PLLRDY_N * 4 ]    @ ������ PLL_RDY (���-������)
                    CMP        R3, 1
                    BNE        label2                 @ ��������� ���������� PLL
                    @ PLL ��������

                    @ ������� �������� Flash
Flash_Latency:      LDR        R2, = PERIPH_BASE + FLASH   @ 0x40022000  ����� �������� FLASH_ACR
                    LDR        R3, [ R2 , FLASH_ACR]
                    BFC        R3, FLASH_ACR_LATENCY_N, FLASH_ACR_LATENCY_L
                    ADD        R3, FLASH_ACR_LATENCY_2
                    STR        R3, [ R2 ]
                   @ �������� Flash ��������

                    @ ���������� sysclk �� pllclk
                    MOV        R6, RCC_CFGR_SW_PLL
                    BFI        R5, R6, 0, 2
                    STR        R5, [ R4 ]
label3:             LDR        R5, [ R4 ]           @ ������ PLL_RDY (���-������)
                    TST        R5, RCC_CFGR_SWS_PLL
                    BEQ        label3               @ ��������� ���������� PLL

                    @ ������������� �� pllclk
                    POP {r0-r6,lr}
                    BX         LR


