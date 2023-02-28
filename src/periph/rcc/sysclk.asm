@.CHARSET CP1251

@ GNU AS
.syntax unified
.cpu cortex-m3
.thumb

@.DESC name=SYSCLK72 type=proc
@ +------------------------------------------------------------+
@ |               Модуль настройки тактирования                |
@ |                                                            |
@ |
@ +------------------------------------------------------------+
@ | микроконтроллер: STM32F103xxx                              |
@ +------------------------------------------------------------+
@ | Модуль настроивает тактирование микроконтроллера           |
@ | на внешний кварцевый генератор HSE с частотой 8 мгц        |
@ | с умножением частоты при помощи блока PLL на 9 до 72 мгц   |
@ +------------------------------------------------------------+
@ | LATENCY = 2 такта ожидания по RM                           |
@ | блок контроля CSS работы HSE не настраивается              |
@ | Тактирование USB осуществляется с дефолтным делителем 1.5  |
@ | от PLLCLK (72 Мгц) RCC_CFGR_USBPRE=0
@ +------------------------------------------------------------+
@ | Видеоурок по подобному модулю: https://youtu.be/Qtu_V-fOAjY|
@ | ArmAsmEditor: STM32 на Ассемблере:  Настройка тактирования |
@ | микроконтроллера на 24 мгц. Видео 11                       |
@ +------------------------------------------------------------+
@.ENDDESC

.INCLUDE  "/src/inc/rcc.inc"
.INCLUDE  "/src/inc/flash.inc"


.GLOBAL   SYSCLK72
SYSCLK72:
                    PUSH {r0-r6,lr}
                    MOV        R1, 1
                    MOV        R0, 0
                    LDR        R2, = PERIPH_BASE + PERIPH_BB_BASE + ( RCC_BASE + RCC_CR ) * 32    @ RCC_CR на битбанг
                    STR        R1, [ R2, RCC_CR_HSEON_N * 4 ]    @ включаем бит HSE_ON в регистре RCC_CR (бит-бангом)
label1:             LDR        R3, [ R2, RCC_CR_HSERDY_N * 4 ]    @ читаем HSE_RDY (бит-бангом)
                    CMP        R3, 1
                    BNE        label1               @ проверяем готовность HSE
                     @ HSE работает

                     @ настройка умножителя PLL
                    LDR        R4, = RCC + RCC_CFGR    @ RCC_CFGR прямой доступ к регистру
                    LDR        R5, = RCC_CFGR_PLLSRC + RCC_CFGR_PLLMUL9 + RCC_CFGR_PPRE1_DIV2
                    STR        R5, [ R4, 0 ]        @ записали RCC_CFGR
                    STR        R1, [ R2, RCC_CR_PLLON_N * 4 ]    @ включаем бит PLL_ON в регистре RCC_CR (бит-бангом)
label2:             LDR        R3, [ R2, RCC_CR_PLLRDY_N * 4 ]    @ читаем PLL_RDY (бит-бангом)
                    CMP        R3, 1
                    BNE        label2                 @ проверяем готовность PLL
                    @ PLL работает

                    @ включим задержку Flash
Flash_Latency:      LDR        R2, = PERIPH_BASE + FLASH   @ 0x40022000  адрес регистра FLASH_ACR
                    LDR        R3, [ R2 , FLASH_ACR]
                    BFC        R3, FLASH_ACR_LATENCY_N, FLASH_ACR_LATENCY_L
                    ADD        R3, FLASH_ACR_LATENCY_2
                    STR        R3, [ R2 ]
                   @ задержка Flash включена

                    @ переключим sysclk на pllclk
                    MOV        R6, RCC_CFGR_SW_PLL
                    BFI        R5, R6, 0, 2
                    STR        R5, [ R4 ]
label3:             LDR        R5, [ R4 ]           @ читаем PLL_RDY (бит-бангом)
                    TST        R5, RCC_CFGR_SWS_PLL
                    BEQ        label3               @ проверяем готовность PLL

                    @ переключились на pllclk
                    POP {r0-r6,lr}
                    BX         LR


