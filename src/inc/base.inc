@GNU AS
@.CharSet=CP1251 (Cyrillic)
@.desc type=module
@ +------------------------------------------------------------------+
@ |                Базовые константы микроконтроллера                |
@ +------------------------------------------------------------------+
@.enddesc

@ базовые константы микроконтроллера

@.ITEM     STM32F1xx
.equ FLASH_BASE            ,0x08000000 @ Адрес Flash
.equ SRAM_BASE             ,0x20000000 @ Адрес SRAM
.equ PERIPH_BASE           ,0x40000000 @ Регистры настройки периферии микроконтроллера
.equ FSMC_R_BASE           ,0xA0000000
.equ CORE                  ,0x00000000 @ Регистры настройки устройств ядра микроконтроллера
.equ DES_BASE              ,0x1FFFF7E0 @ Device electronic signature
@.end


@.item PERIPH_BASE
.equ PERIPH_BB_BASE        ,0x02000000
.equ APB1PERIPH_BASE       ,0x00000000
.equ APB2PERIPH_BASE       ,0x00010000
.equ AHBPERIPH_BASE        ,0x00020000
@.end

@.item CORE
.equ CORE_BASE             ,0xE0000000   @ начало раздела Core-регистров
.equ ITM_BASE              ,0xE0000000   @ адреса согласно CMSIS
.equ DWT_BASE              ,0xE0001000   @ Data Watchpoint and Trace (DWT)
.equ SCnSCB_BASE           ,0xE000E000   @ System control Register not in SCB
.equ SCS_BASE              ,0xE000E000   @ System Control Space Base Address
.equ SysTick_BASE          ,0xE000E010   @ System Tick Timer (SysTick)
.equ NVIC_BASE             ,0xE000E100   @ Nested Vectored Interrupt Controller (NVIC)
.equ SCB_BASE              ,0xE000ED00   @ System Control Block Base Address
.equ MPU_BASE              ,0xE000ED90   @ Memory Protection Unit (MPU)
.equ CoreDebug_BASE        ,0xE000EDF0   @
.equ TPI_BASE              ,0xE0040000   @ Trace Port Interface (TPI)

.equ MCU_IDCODE            ,0xE0042000  @ не CMSIS определение
@.end


@.item SRAM_BASE
.equ SRAM_BB_BASE         ,0x02000000
@.end

@.item COUNT_OF_GPIOS
.equ GPIOS_COUNT          ,0x3
@.end


