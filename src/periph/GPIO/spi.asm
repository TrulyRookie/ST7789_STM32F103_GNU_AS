@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор
@=============================================================================
@| 1) SPI_CR1->BRP[2..0]  - init baud rate
@|                  000: fPCLK/2
@|                  001: fPCLK/4
@|                  010: fPCLK/8
@|                  011: fPCLK/16
@|                  100: fPCLK/32
@|                  101: fPCLK/64
@|                  110: fPCLK/128
@|                  111: fPCLK/256
@| 2) SPI_CR1->CPOL 0 - start from low, 1 - start from hi;
@|    SPI_CR1->CPHA 0 - The first clock transition is the first data capture edge, 1 - The second clock transition is the first data capture edge
@| 3) SPI_CR1->DFF 0 - 8bit, 1 - 16bit
@| 4) SPI_CR1->LSBFIRST 0 - highest bit first, 1 - lower bit first
@| 5) SPI_CR1->SSM 0 - Software slave management disabled 1 - Software slave management enabled
@| 6) SPI_CR1->SSI This bit has an effect only when the SSM bit is set. The value of this bit is forced onto the NSS pin and the IO value of the NSS pin is ignored.
@| 7) SPI_CR1->MSTR 0 - slave mode, 1 - master mode; SPI_CR1->SPE 0 - disable spi, 1 - enable spi
@| Halfduplex bidirectional: SPI_CR1->BIDIMODE=1, SPI_CR1->BIDIOE = 1 - transfert, 0 - receive
@|
@| GPIOA: PIN5 - SCLK, PIN7 - MOSI, PIN4 - CS, PIN6 - RESET (push-pull, output)
@| GPIOB: PIN0 - DC (0 - data is command, 1 - data is parameter)
@=============================================================================
.include "/src/inc/spi.inc"
.include "/src/inc/dma.inc"
.include "/src/inc/gpio.inc"
.include "/src/inc/rcc.inc"
.include "/src/inc/utils.inc"
.include "/src/inc/dma.inc"

.section .bss
     .align(2)
@**************SPI VARIABLES*************************
CS_BB_SET:  .word 0
CS_BB_RESET:.word 0
DC_BB_SET:  .word 0
DC_BB_RESET:.word 0
RST_BB_SET:  .word 0
RST_BB_RESET:.word 0
.section .asmcode

.global WAIT_TXE
WAIT_TXE:
push {r0,r1,lr}
     BBP R0, SPI1_BASE, SPI_SR, SPI_SR_TXE_N
WAIT_TXE_1:
     LDR r1, [r0]
     TST r1, #1
     BEQ WAIT_TXE_1
pop {r0,r1,lr}
bx lr


.global WAIT_BSY
WAIT_BSY:
push {r0,r1,lr}
     BBP R0, SPI1_BASE, SPI_SR, SPI_SR_BSY_N
WAIT_BSY_0:
     LDR r1, [r0]
     TST r1, #1
     BNE WAIT_BSY_0
pop {r0,r1,lr}
bx lr

.global SPI1_Init
SPI1_Init:
     PUSH {r0-r3,lr}
     @**** CS ****
     LDR r0, =SPI_CS_GPIO
     MOV r1, SPI_CS_NUM
     LDR r2, =OUTPUT_50_PP|PIN_SET_PULLUP
     BL GPIO_PinTuning
     LDR r0, =CS_BB_SET
     LDR r1, =CS_BB_RESET
     STR r5, [r0]
     STR r6, [r1]
     @**** DC ****
     LDR r0, =SPI_DC_GPIO
     MOV r1, SPI_DC_NUM
     MOV r2, OUTPUT_50_PP
     BL GPIO_PinTuning
     LDR r0, =DC_BB_SET
     LDR r1, =DC_BB_RESET
     STR r5, [r0]
     STR r6, [r1]
     @**** RST ****
     LDR r0, =SPI_RST_GPIO
     MOV r1, SPI_RST_NUM
     LDR r2, =OUTPUT_50_PP|PIN_SET_PULLUP
     BL GPIO_PinTuning
     LDR r0, =RST_BB_SET
     LDR r1, =RST_BB_RESET
     STR r5, [r0]
     STR r6, [r1]
     @**** MOSI ****
     LDR r0, =GPIOA
     MOV r1, 7
     MOV r2, OUTPUT_50_AFPP
     BL GPIO_PinTuning
     @**** SCLK ****
     LDR r0, =GPIOA
     MOV r1, 5
     MOV r2, OUTPUT_50_AFPP
     BL GPIO_PinTuning

     BBP r0, RCC_BASE, RCC_APB2ENR, RCC_APB2ENR_SPI1EN_N
     STR r12, [r0]

     LDR R0, =SPI_SETTINGS_MHBTRSO_8_36_SCKHI_FRONT
     LDR R1, =(SPI1+SPI_CR1)
     STR r0, [r1]

     BBP R0, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N
     STR R12, [R0]                                     @SPI ON

     POP {r0-r3, lr}
     BX LR

SelectSlave:
push {r0,lr}
     LVR r0, CS_BB_RESET
     STR r12, [r0]
pop {r0, lr}
bx LR

ReleaseSlave:
push {r0,lr}
     LVR r0, CS_BB_SET
     STR r12, [r0]
pop {r0, lr}
bx LR

DataIsCommand:
push {r0,lr}
     LVR r0, DC_BB_RESET
     STR r12, [r0]
pop {r0, lr}
bx LR

DataIsParameter:
push {r0,lr}
     LVR r0, DC_BB_SET
     STR r12, [r0]
pop {r0, lr}
bx LR

.global HardResetDisplay
HardResetDisplay:
push {r0,r1,lr}
     LVR r2, RST_BB_RESET
     LVR r1, RST_BB_SET
     STR r12, [r2]
     MOV r0, #10
     BL SYSTICK_DELAY
     STR r12, [r1]
     MOV r0, #100
     BL SYSTICK_DELAY
pop {r0,r1,lr}
bx LR
@.DESC    name=SendData type=proc
@ Subroutine for sending data to the LCD
@****************************************
@ IN:
@    R0 - data
@    R1 - type of data (0 - command, 1 - parameters)
@ OUT: NONE
@.ENDDESC
.global SendData
SendData:
push {r0-r4,lr}
     CBNZ r1, Send_Param                        @ if  (dataType is Parameter) DataIsParameter();
     BL DataIsCommand                           @ else DataIsCommand();
     B SendData0
Send_Param:
     BL DataIsParameter
SendData0:
     BL WAIT_TXE                                @ Wait until TXE not setup to 1
     BL SelectSlave                             @ Select LCD to receive data
     CMP r0, 0xFF                               @ if (data is Pointer) SendData_Bulk();
     BHI SendData_Bulk
     BBP r3, SPI1_BASE, SPI_CR1, SPI_CR1_DFF_N
     LDR r2, [r3]                               @ Take DFF flag state
     CBZ r2, SendData_IsByte                    @ if (DFF == 0) goto data_is_byte
     BBP R2, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N  @ else{
     STR r11, [r2]                              @ SPI off
     STR r11, [r3]                              @ clear DFF
     STR r12, [r2]                              @ SPI on}
SendData_IsByte:
     LDR r1, =(SPI1 + SPI_DR)                   @ Take TX buffer address
     STRB r0, [r1]                              @ Send data
     BL SendData_Return                         @ Return
SendData_Bulk:
     .if SPI_DMA_USE==1
          BL SendByDMA
     .else
          BL SendArray
     .endif
     BL WAIT_TXE
     BL WAIT_BSY
SendData_Return:
     BL ReleaseSlave
pop {r0-r4,lr}
bx lr

SendByDMA:
bx lr

SendArray:                                       @ SendArray(&array)
push {r0-r5, lr}
     LDR r1, [r0,-4]                             @ Get size word of array
     UBFX r2, r1, #16, #2                        @ Get data size in power of 2
     UBFX r1, r1, #0, #16                        @ Get data count
     CBNZ r2, HWORD_send                         @ if (dataSize > 0) goto  IsHWORD
     LSL r1, r1, r2                              @ size in bytes dataCount<<dataSize
     BBP r3, SPI1_BASE, SPI_CR1, SPI_CR1_DFF_N
     LDR r2, [r3]                                @ take DFF flag state
     CBZ r2, SendArray_IsByte                    @ if (DFF==0) goto isByte
     BBP R2, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N   @ else configure DFF to byte sending
     STR r11, [r2]                               @ SPI OFF
     STR r11, [r3]                               @ DFF clear
     STR r12, [r2]                               @ SPI ON
SendArray_IsByte:
     MOV r2, #0                                  @ CYCLE_COUNTER = 0
     LDR r5, =(SPI1+SPI_DR)                      @ Take TX buffer address
SendArray_SendLoopByte:                          @ do{
     BL WAIT_TXE                                 @ wait until TXE != 1
     LDRB r3, [r0,r2]                            @ read data byte from memory buffer
     STRB r3, [r5]                               @ write data byte to TX buffer
     ADD r2, #1                                  @ CYCLE_COUNTER++
     CMP r2, r1                                  @ }while(CYCLE_COUNTER!=dataCount)
     BNE SendArray_SendLoopByte
     B SendArray_Return                          @return;
HWORD_send:
     BBP r3, SPI1_BASE, SPI_CR1, SPI_CR1_DFF_N
     LDR r2, [r3]
     CBNZ r2, SendArray_IsHword                  @ if (DFF == 1) goto isHWORD
     BBP R2, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N   @ else configure DFF to HWORD sending
     STR r11, [r2]                               @ SPI OFF
     STR r12, [r3]                               @ DFF set
     STR r12, [r2]                               @ SPI ON
SendArray_IsHword:
     MOV r2, #0
     LDR r5, =(SPI1+SPI_DR)
SendArray_SendLoopHWORD:
     BL WAIT_TXE
     LDRH r3, [r0,r2]
     STRH r3, [r5]
     ADD r2, #1
     CMP r2, r1
     BNE SendArray_SendLoopHWORD
SendArray_Return:
pop {r0-r5, lr}
BX LR


