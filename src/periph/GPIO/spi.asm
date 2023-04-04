@.CHARSET =CP1251
@GNU AS

.SYNTAX unified   @ синтаксис исходного кода
.THUMB   @ тип используемых инструкций Thumb
.CPU cortex-m3   @ процессор
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
.INCLUDE   "/src/inc/spi.inc"
.INCLUDE   "/src/inc/dma.inc"
.INCLUDE   "/src/inc/gpio.inc"
.INCLUDE   "/src/inc/rcc.inc"
.INCLUDE   "/src/inc/utils.inc"
.INCLUDE   "/src/inc/nvic.inc"

.GLOBAL CS_BB_SET
.GLOBAL CS_BB_RESET
.GLOBAL DC_BB_SET
.GLOBAL DC_BB_RESET
.GLOBAL RST_BB_SET
.GLOBAL RST_BB_RESET
.GLOBAL TXE_BB
.GLOBAL BSY_BB
.GLOBAL SPI_VAR
.GLOBAL SPI_DR_ADDR
.GLOBAL SPI1_Init

.SECTION .bss
.ALIGN ( 2 )
@**************SPI VARIABLES*************************
SPI_VAR:
CS_BB_SET:     .WORD  0
CS_BB_RESET:   .WORD  0
DC_BB_SET:     .WORD  0
DC_BB_RESET:   .WORD  0
RST_BB_SET:    .WORD  0
RST_BB_RESET:  .WORD  0
TXE_BB:        .WORD  0
BSY_BB:        .WORD  0
SPI_DR_ADDR:   .WORD  0

.SECTION .asmcode

SPI1_Init:
     PUSH  { R0 - R3, LR }
     LDR R7, =SPI_VAR
     @**** CS ****
     LDR  R0, = SPI_CS_GPIO
     MOV  R1, SPI_CS_NUM
     LDR  R2, = OUTPUT_50_PP | PIN_SET_PULLUP
     BL  GPIO_PinTuning
     STR  R5, [ R7, CS_BB_SET - SPI_VAR ]
     STR  R6, [ R7, CS_BB_RESET - SPI_VAR ]
     @**** DC ****
     LDR  R0, = SPI_DC_GPIO
     MOV  R1, SPI_DC_NUM
     MOV  R2, OUTPUT_50_PP
     BL  GPIO_PinTuning
     STR  R5, [ R7, DC_BB_SET - SPI_VAR ]
     STR  R6, [ R7, DC_BB_RESET - SPI_VAR ]
     @**** RST ****
     LDR  R0, = SPI_RST_GPIO
     MOV  R1, SPI_RST_NUM
     LDR  R2, = OUTPUT_50_PP | PIN_SET_PULLUP
     BL  GPIO_PinTuning
     STR  R5, [ R7, RST_BB_SET - SPI_VAR ]
     STR  R6, [ R7, RST_BB_RESET - SPI_VAR ]
     @**** MOSI ****
     LDR  R0, = GPIOA
     MOV  R1, 7
     MOV  R2, OUTPUT_50_AFPP
     BL  GPIO_PinTuning
     @**** SCLK ****
     LDR  R0, = GPIOA
     MOV  R1, 5
     MOV  R2, OUTPUT_50_AFPP
     BL  GPIO_PinTuning

     BBP  R0, SPI1_BASE, SPI_SR, SPI_SR_TXE_N
     LDR  R8, = TXE_BB
     STR  R0, [ R8 ]
     MOV  R8, R0

     BBP  R0, SPI1_BASE, SPI_SR, SPI_SR_BSY_N
     LDR  R9, = BSY_BB
     STR  R0, [ R9 ]
     MOV  R9, R0

     LDR R10, =SPI1+SPI_DR
     LDR R1, = SPI_DR_ADDR
     STR R10, [R1]

     BBP  r0, RCC_BASE, RCC_APB2ENR, RCC_APB2ENR_SPI1EN_N
     STR  R12, [ R0 ]
     LDR  R0, = SPI_SETTINGS_MHBTRSO_8_36_SCKHI_FRONT
     LDR  R1, = ( SPI1 + SPI_CR1 )
     STR  R0, [ R1 ]

     BBP  R0, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N
     STR  R12, [ R0 ]                   @SPI ON

.IF ( SPI_DMA_USE == 1 )
     BL  DMA1_Init
     BBP  R0, SPI1_BASE, SPI_CR2, SPI_CR2_TXDMAEN_N
     STR  R12, [ R0 ]
     BBP  R0, SPI1_BASE, SPI_CR2, SPI_CR2_RXDMAEN_N
     STR  R12, [ R0 ]
.ENDIF
     POP  { R0 - R3, LR }
     BX  LR
@********* Service subroutines *******************
.GLOBAL WAIT_TXE
WAIT_TXE:
     PUSH  { R0, R1, LR }
     BBP  R0, SPI1_BASE, SPI_SR, SPI_SR_TXE_N
WAIT_TXE_1:
     LDR  R1, [ R0 ]
     TST  R1, #1
     BEQ  WAIT_TXE_1
     POP  { R0, R1, LR }
     BX  LR

.GLOBAL WAIT_BSY
WAIT_BSY:
     PUSH  { R0, R1, LR }
     BBP  R0, SPI1_BASE, SPI_SR, SPI_SR_BSY_N
WAIT_BSY_0:
     LDR  R1, [ R0 ]
     TST  R1, #1
     BNE  WAIT_BSY_0
     POP  { R0, R1, LR }
     BX  LR
.global SelectSlave
SelectSlave:
     PUSH  { R0, LR }
     SELECT_SLAVE R0
     POP  { R0, LR }
     BX  LR
.global ReleaseSlave
ReleaseSlave:
     PUSH  { R0, LR }
     RELEASE_SLAVE R0
     POP  { R0, LR }
     BX  LR
.global DataIsCommand
DataIsCommand:
     PUSH  { R0, LR }
     IS_COMMAND R0
     POP  { R0, LR }
     BX  LR
.global DataIsParameter
DataIsParameter:
     PUSH  { R0, LR }
     IS_PARAMETER R0
     POP  { R0, LR }
     BX  LR

.global SendCommand
SendCommand:
     PUSH {r0, r1, LR}
     IS_COMMAND R1
     SEND_BYTE SC00, R0, R1
     END_CHECK SC01, R1
     POP {r0, r1, LR}
     BX LR

.global SendParameter
SendParameter:
     PUSH {r0, r1, LR}
     IS_PARAMETER R1
     SEND_BYTE SP00, R0, R1
     END_CHECK SP01, R1
     POP {r0, r1, LR}
     BX LR

.global Send4BParameters
Send4BParameters:
     PUSH {r0-r2, LR}
     IS_PARAMETER R1
     UBFX R1, R0, #24, #8
     SEND_BYTE S4P00, R1, R2
     UBFX R1, R0, #16, #8
     SEND_BYTE S4P01, R1, R2
     UBFX R1, R0, #8, #8
     SEND_BYTE S4P02, R1, R2
     UBFX R1, R0, #0, #8
     SEND_BYTE S4P03, R1, R2
     END_CHECK S4P04, R2
     POP {r0-r2, LR}
     BX LR

.global Send2BParameters
Send2BParameters:
     PUSH {r0-r2, LR}
     IS_PARAMETER R1
     UBFX R1, R0, #8, #8
     SEND_BYTE S2P02, R1, R2
     UBFX R1, R0, #0, #8
     SEND_BYTE S2P03, R1, R2
     END_CHECK S2P04, R2
     POP {r0-r2, LR}
     BX LR

.global SendParameters
SendParameters:
     push {r1, LR}
     IS_PARAMETER R1
     .if (SPI_DMA_USE==1)
          BL DMABulkSend
     .else
          BL ArraySend
     .endif
     pop {r1, LR}
     bx lr
.global ResetRegisters
ResetRegisters:
     REFRESH_REGISTERS
     BX LR
.GLOBAL HardResetDisplay
HardResetDisplay:
     PUSH  { R0, R1, LR }
     LDR  R0, = SPI_VAR
     LDR  R1, [ R0, RST_BB_SET - SPI_VAR ]
     LDR  R0, [ R0, RST_BB_RESET - SPI_VAR ]
     STR  R12, [ R0 ]
     MOV  R0, #10
     BL  SYSTICK_DELAY
     STR  R12, [ R1 ]
     MOV  R0, #100
     BL  SYSTICK_DELAY
     POP  { R0, R1, LR }
     BX  LR

.IF ( SPI_DMA_USE == 1 )
@.DESC    name = DMABulkSend type = proc
@******************************************************************************
@*                             Bulk of data send by DMA                       *
@******************************************************************************
@*   IN: R5 - array pointer, R6 - repeat counter                              *
@******************************************************************************
@.ENDDESC
.global DMABulkSend
DMABulkSend: @DMABulkSend(T* buff, int repeats)
PUSH {R0-R3,LR}
     LDRH R1, [ R5, - 4 ]
     LDRH R0, [ R5, - 2 ]
     LSL R1, R1, R0
     LDR R0, =DMA1
     STR R5, [ R0, DMA_CMAR3 ]
     STR R1, [ R0, DMA_CNDTR3 ]
     BBP R3, DMA1_BASE, DMA_CCR3, 0
     CBZ R6, DMA_SINGLE
     STR R12, [R3, 5*4] @CIRCULAR MODE ON
     STR R12, [R3, 1*4] @DMA IRQ CH 3 ON
DMA_SINGLE:
     GET_TXE R0
     CMP R0, #1
     BNE DMA_SINGLE
     STR  R12, [R3]   @DMA channel 3 ON
DMA_CIRC_COUNTER_NOT_NULL:
     CMP  R6, #0
     BNE  DMA_CIRC_COUNTER_NOT_NULL
     END_CHECK DMA00, R0
     STR R11, [R3]    @DMA channel 3 OFF
     BBP R0, DMA1_BASE, DMA_IFCR, DMA_IFCR_CGIF3_N
     STR R12, [r0]
     @IS_COMMAND R0
POP {R0-R3,LR}
BX LR
.ELSE
.global ArraySend
ArraySend: @ SendArray(&array)
     PUSH  { R0 - R3, LR }
     LDRH  R1, [ R5, - 4 ]                   @ Get size word of array
     LDRH  R0, [ R5, - 2 ]
     LSL  R1, R1, R0                         @ size in bytes dataCount<<dataSize
SendArray_RepLoop:                           @<-------------------------|
     MOV  R0, #0                             @ CYCLE_COUNTER = 0        |
SendArray_TXE_1:                             @ <- - - <- - -            |
     GET_TXE R2                              @      | TXE  |            |
     CMP  R2, #1                             @      | LOOP |            |
     BNE  SendArray_TXE_1                    @- - - -      |            |
                                             @             |            |
     LDRB  R2, [ R5, R0 ]                    @             |            |
     STRB  R2, [ R10 ]                       @             |            |
                                             @             |            |
     ADD  R2, #1                             @             |            |
     CMP  R2, R1                             @             |            |
     BNE  SendArray_TXE_1                    @-- - - - - - -MAIN LOOP   |
     CMP r6, #0                              @                          | Repeate loop
     ITT NE                                  @                          |
     SUBNE r6, #1                            @                          |
     BNE SendArray_RepLoop                   @--------------------------|

     END_CHECK SendArray00, R0
     @IS_COMMAND R0

     POP  { R0 - R3, LR }
     BX  LR
.ENDIF

.global SendData
SendData:BX LR


