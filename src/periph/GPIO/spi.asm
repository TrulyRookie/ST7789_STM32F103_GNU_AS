@.CHARSET =CP1251
@GNU AS

.SYNTAX unified   @ синтаксис исходного кода
.THUMB       @ тип используемых инструкций Thumb
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

.SECTION .bss
.ALIGN ( 2 )
@**************SPI VARIABLES*************************
CS_BB_SET: .WORD  0
CS_BB_RESET: .WORD  0
DC_BB_SET: .WORD  0
DC_BB_RESET: .WORD  0
RST_BB_SET: .WORD  0
RST_BB_RESET: .WORD  0
.SECTION .asmcode

.GLOBAL SPI1_Init
SPI1_Init:
          PUSH  { R0 - R3, LR }
     @**** CS ****
          LDR  R0, = SPI_CS_GPIO
          MOV  R1, SPI_CS_NUM
          LDR  R2, = OUTPUT_50_PP | PIN_SET_PULLUP
          BL  GPIO_PinTuning
          LDR  R0, = CS_BB_SET
          LDR  R1, = CS_BB_RESET
          STR  R5, [ R0 ]
          STR  R6, [ R1 ]
     @**** DC ****
          LDR  R0, = SPI_DC_GPIO
          MOV  R1, SPI_DC_NUM
          MOV  R2, OUTPUT_50_PP
          BL  GPIO_PinTuning
          LDR  R0, = DC_BB_SET
          LDR  R1, = DC_BB_RESET
          STR  R5, [ R0 ]
          STR  R6, [ R1 ]
     @**** RST ****
          LDR  R0, = SPI_RST_GPIO
          MOV  R1, SPI_RST_NUM
          LDR  R2, = OUTPUT_50_PP | PIN_SET_PULLUP
          BL  GPIO_PinTuning
          LDR  R0, = RST_BB_SET
          LDR  R1, = RST_BB_RESET
          STR  R5, [ R0 ]
          STR  R6, [ R1 ]
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

          BBP  r0, RCC_BASE, RCC_APB2ENR, RCC_APB2ENR_SPI1EN_N
          STR  R12, [ R0 ]

          LDR  R0, = SPI_SETTINGS_MHBTRSO_8_36_SCKHI_FRONT
          LDR  R1, = ( SPI1 + SPI_CR1 )
          STR  R0, [ R1 ]

          BBP  R0, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N
          STR  R12, [ R0 ]    @SPI ON

.IF ( SPI_DMA_USE == 1 )
          BL  DMA1_Init
          BBP R0, SPI1_BASE, SPI_CR2, SPI_CR2_TXDMAEN_N
          STR R12, [r0]
          BBP R0, SPI1_BASE, SPI_CR2, SPI_CR2_RXDMAEN_N
          STR R12, [r0]
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

SelectSlave:
          PUSH  { R0, LR }
          LVR  r0, CS_BB_RESET
          STR  R12, [ R0 ]
          POP  { R0, LR }
          BX  LR

ReleaseSlave:
          PUSH  { R0, LR }
          LVR  r0, CS_BB_SET
          STR  R12, [ R0 ]
          POP  { R0, LR }
          BX  LR

DataIsCommand:
          PUSH  { R0, LR }
          LVR  r0, DC_BB_RESET
          STR  R12, [ R0 ]
          POP  { R0, LR }
          BX  LR

DataIsParameter:
          PUSH  { R0, LR }
          LVR  r0, DC_BB_SET
          STR  R12, [ R0 ]
          POP  { R0, LR }
          BX  LR

.GLOBAL HardResetDisplay
HardResetDisplay:
          PUSH  { R0, R1, LR }
          LVR  r2, RST_BB_RESET
          LVR  r1, RST_BB_SET
          STR  R12, [ R2 ]
          MOV  R0, #10
          BL  SYSTICK_DELAY
          STR  R12, [ R1 ]
          MOV  R0, #100
          BL  SYSTICK_DELAY
          POP  { R0, R1, LR }
          BX  LR

.GLOBAL SwitchSPIto8bitMode
SwitchSPIto8bitMode:
push {r0,r1,lr}
     BBP  r0, SPI1_BASE, SPI_CR1, SPI_CR1_DFF_N
     LDR  R1, [ R0 ]                                        @ Take DFF flag state
     CBZ  R1, SPI_SW_8_RET                                  @ if (DFF == 0) return;
     BBP  R1, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N             @ else{
     STR  R11, [ R1 ]                                       @ SPI off
     STR  R11, [ R0 ]                                       @ clear DFF
     STR  R12, [ R1 ]                                       @ SPI on}
SPI_SW_8_RET:
pop {r0,r1,lr}
bx LR

.GLOBAL SwitchSPIto16bitMode
SwitchSPIto16bitMode:
push {r0,r1,lr}
     BBP  r0, SPI1_BASE, SPI_CR1, SPI_CR1_DFF_N
     LDR  R1, [ R0 ]                                        @ Take DFF flag state
     CBNZ  R1, SPI_SW_16_RET                                @ if (DFF == 1) return;
     BBP  R1, SPI1_BASE, SPI_CR1, SPI_CR1_SPE_N             @ else{
     STR  R11, [ R1 ]                                       @ SPI off
     STR  R12, [ R0 ]                                       @ set DFF
     STR  R12, [ R1 ]                                       @ SPI on}
SPI_SW_16_RET:
pop {r0,r1,lr}
bx LR

.GLOBAL SwitchDMAto8bitMode_ch3
SwitchDMAto8bitMode_ch3:
PUSH {R0,LR}
     BBP R0, DMA1_BASE, DMA_CCR3, 0
     STR R11, [R0] @DMA channel 3 OFF
     BBP R0, DMA1_BASE, DMA_CCR3, 10      @MSize low bit
     STR R11, [R0] @8bit memory
     BBP R0, DMA1_BASE, DMA_CCR3, 8      @PSize low bit
     STR R11, [R0] @8bit peripheria
POP {R0,LR}
BX LR

.GLOBAL SwitchDMAto16bitMode_ch3
SwitchDMAto16bitMode_ch3:
PUSH {R0,LR}
     BBP R0, DMA1_BASE, DMA_CCR3, 0
     STR R11, [R0] @DMA channel 3 OFF
     BBP R0, DMA1_BASE, DMA_CCR3, 10      @MSize low bit
     STR R12, [R0] @16bit memory
     BBP R0, DMA1_BASE, DMA_CCR3, 8      @PSize low bit
     STR R12, [R0] @16bit peripheria
POP {R0,LR}
BX LR

.GLOBAL SwitchTo8bitTransferMode
SwitchTo8bitTransferMode:
push {lr}
     BL WAIT_TXE
     BL WAIT_BSY
     BL ReleaseSlave
     BL SwitchSPIto8bitMode
     BL SwitchDMAto8bitMode_ch3
pop {lr}
BX LR

.GLOBAL SwitchTo16bitTransferMode
SwitchTo16bitTransferMode:
push {lr}
     BL WAIT_TXE
     BL WAIT_BSY
     BL ReleaseSlave
     BL SwitchSPIto16bitMode
     BL SwitchDMAto16bitMode_ch3
pop {lr}
BX LR

@**********Data send subroutines*******************

@.DESC     name=SendData type=proc
@ Subroutine for sending data to the LCD
@****************************************
@ IN:
@    R0 - data
@    R1 - type of data (0 - command, 1 - parameters)
@ OUT: NONE
@.ENDDESC
.GLOBAL SendData
SendData:
          PUSH  { R0 - R4, LR }
          CBNZ  R1, Send_Param    @ if  (dataType is Parameter) DataIsParameter();
          BL  DataIsCommand    @ else DataIsCommand();
          B   SendData0
Send_Param:
          BL  DataIsParameter
SendData0:
          CMP  R0, 0xFF       @ if (data is Pointer) SendData_Bulk();
          BHI  SendData_Bulk
          @BL SwitchSPIto8bitMode
          BL  WAIT_TXE        @ Wait until TXE not setup to 1
          BL  SelectSlave     @ Select LCD to receive data
          LDR  R1, = ( SPI1 + SPI_DR )    @ Take TX buffer address
          STRB  R0, [ R1 ]    @ Send data
          BL  SendData_Return    @ Return
SendData_Bulk:
.IF SPI_DMA_USE == 1
          BL  SendByDMA
.ELSE
          BL  SendArray
.ENDIF
          BL  WAIT_TXE
          BL  WAIT_BSY
SendData_Return:
          BL  ReleaseSlave
          POP  { R0 - R4, LR }
          BX  LR

SendByDMA:
          PUSH  { R0 - R5, LR }
          LDR  R1, [ R0, - 4 ]    @ Get size word of array
          UBFX  R2, R1, #16, #2    @ Get data size in power of 2
          UBFX  R1, R1, #0, #16    @ Get data count
          LDR R3, =(DMA1+DMA_CMAR3)
          STR R0, [R3]
          CBNZ  R2, DMA_HWORD_SEND    @ if (dataSize > 0) goto  IsHWORD
          LSL  R1, R1, R2     @ size in bytes dataCount<<dataSize
          @BL SwitchSPIto8bitMode
          @BL SwitchDMAto8bitMode_ch3
          B DMAArray_Send
DMA_HWORD_SEND:
          @BL SwitchSPIto16bitMode
          @BL SwitchDMAto16bitMode_ch3
DMAArray_Send:
          LDR R2, =(DMA1+DMA_CNDTR3)
          STR R1, [R2]
          BL WAIT_TXE
          BL  SelectSlave
          BBP R3, DMA1_BASE, DMA_CCR3, 0
          STR R12, [R3]                      @DMA channel 3 ON
          BBP R3, DMA1_BASE, DMA_ISR, DMA_ISR_TCIF3_N
DMAArray_Return:
          LDR R2, [R3]
          CMP R2, #1
          BNE DMAArray_Return
          BBP R3, DMA1_BASE, DMA_IFCR, 8
          STR R12, [r3]                      @clear interrupt flags
          BBP R3, DMA1_BASE, DMA_CCR3, 0
          STR R11, [R3]                      @DMA channel 3 OFF
          POP  { R0 - R5, LR }
          BX  LR

SendArray: @ SendArray(&array)
          PUSH  { R0 - R5, LR }
          LDR  R1, [ R0, - 4 ]          @ Get size word of array
          UBFX  R2, R1, #16, #2         @ Get data size in power of 2
          UBFX  R1, R1, #0, #16         @ Get data count
          CBNZ  R2, HWORD_send          @ if (dataSize > 0) goto  IsHWORD
          LSL  R1, R1, R2               @ size in bytes dataCount<<dataSize
          @BL SwitchSPIto8bitMode
SendArray_IsByte:
          BL  SelectSlave
          MOV  R2, #0                   @ CYCLE_COUNTER = 0
          LDR  R5, = ( SPI1 + SPI_DR )  @ Take TX buffer address
SendArray_SendLoopByte:                 @ do{
          BL  WAIT_TXE                  @ wait until TXE != 1
          LDRB  R3, [ R0, R2 ]          @ read data byte from memory buffer
          STRB  R3, [ R5 ]              @ write data byte to TX buffer
          ADD  R2, #1                   @ CYCLE_COUNTER++
          CMP  R2, R1                   @ }while(CYCLE_COUNTER!=dataCount)
          BNE  SendArray_SendLoopByte
          B   SendArray_Return          @return;
HWORD_send:
          @BL SwitchSPIto16bitMode
SendArray_IsHword:
          BL  SelectSlave
          MOV  R2, #0
          LDR  R5, = ( SPI1 + SPI_DR )
SendArray_SendLoopHWORD:
          BL  WAIT_TXE
          LDRH  R3, [ R0, R2, LSL #1 ]
          STRH  R3, [ R5 ]
          ADD  R2, #1
          CMP  R2, R1
          BNE  SendArray_SendLoopHWORD
SendArray_Return:
          POP  { R0 - R5, LR }
          BX  LR

.if (SPI_DMA_USE==1)
@IN r0 - &array, r1 - count
.GLOBAL DMA_hSendCircular
DMA_hSendCircular:
     push {r0-r4,lr}
          BL DataIsParameter
          LDR R2, =DMA_CIRCULAR_COUNTER
          STR R1, [R2]
          @BL SwitchSPIto16bitMode
@DMA_Circ_label0:
          @BL SwitchDMAto16bitMode_ch3
          BBP R4, DMA1_BASE, DMA_CCR3, 5      @Circular bit
          STR R12, [R4]
          LDR  R1, [ R0, - 4 ]    @ Get size word of array
          UBFX  R2, R1, #16, #2    @ Get data size in power of 2
          UBFX  R1, R1, #0, #16    @ Get data count
          LDR R3, =DMA1
          STR R0, [R3, DMA_CMAR3]
          STR R1, [R3, DMA_CNDTR3]
          BL WAIT_TXE
          BL  SelectSlave
          LDR R2, =NVIC_BASE+NVIC_ISER0
          MOV R3, 1
          LSL R3, R3, #13
          LDR R4, [R2]
          ORR R4, R3
          STR R4, [R2]
          BBP R3, DMA1_BASE, DMA_CCR3, 1
          STR R12, [R3] @DMA IRQ CH 3 ON
          BBP R3, DMA1_BASE, DMA_CCR3, 0
          STR R12, [R3] @DMA channel 3 ON
          LDR R0, =DMA_CIRCULAR_COUNTER
DMA_CIRC_COUNTER_NOT_NULL:
          LDR R1, [R0]
          CMP R1, #0
          BNE DMA_CIRC_COUNTER_NOT_NULL
          BL WAIT_TXE
          BL WAIT_BSY
          BL ReleaseSlave
     pop {r0-r4,lr}
     BX LR
.endif

