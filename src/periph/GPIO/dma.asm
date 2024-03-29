@.CHARSET =CP1251
@GNU AS

.SYNTAX unified   @ ��������� ��������� ����
.THUMB       @ ��� ������������ ���������� Thumb
.CPU cortex-m3   @ ���������

@==================================================================================
@ 1. Set the peripheral register address in the DMA_CPARx register. The data will be
@ moved from/ to this address to/ from the memory after the peripheral event.
@ 2. Set the memory address in the DMA_CMARx register. The data will be written to or
@ read from this memory after the peripheral event.
@ 3. Configure the total number of data to be transferred in the DMA_CNDTRx register.
@ After each peripheral event, this value will be decremented.
@ 4. Configure the channel priority using the PL[1:0] bits in the DMA_CCRx register
@ 5. Configure data transfer direction, circular mode, peripheral & memory incremented
@ mode, peripheral & memory data size, and interrupt after half and/or full transfer in the
@ DMA_CCRx register
@ 6. Activate the channel by setting the ENABLE bit in the DMA_CCRx register.
@==================================================================================
.INCLUDE   "/src/inc/dma.inc"
.INCLUDE   "/src/inc/spi.inc"
.INCLUDE   "/src/inc/nvic.inc"
.INCLUDE   "/src/inc/rcc.inc"
.INCLUDE   "/src/inc/utils.inc"
.GLOBAL DMA_CIRCULAR_COUNTER
.SECTION .bss
.ALIGN ( 2 )
DMA_CIRCULAR_COUNTER: .WORD  0
.SECTION .asmcode

.GLOBAL DMA1_Init

DMA1_Init:
          PUSH  { R0 - R4, LR }
     @ DMA1 clock enable
          BBP  r1, RCC_BASE, RCC_AHBENR, RCC_AHBENR_DMA1EN_N @ bit-banding DMA1 clock enable bit
          MOV  R2, #1         @ r2 <- 1
          STR  R2, [ R1 ]     @ r2 -> [r1] enable DMA1
     @ DMA ch2 and ch3 setup
          @address RX in periph dma register
          LDR  R1, = DMA1                @ r1 <- pDMA1
          LDR  R2, = SPI1 + SPI_DR    @ r2 <- SPI1_DR_ADDR (address IO SPI register)
          STR  R2, [ R1, DMA_CPAR2 ]     @ SPI1_DR_ADDR{r2} -> *pDMA1_CPAR2{[r1]}

          @address TX in periph dma register
          STR  R2, [ R1, DMA_CPAR3 ]

     @ ch 3 - SPI1 TX, ch 2 - SPI1 RX
          LDR  R4, = DMA_CCR_PL_LOW | DMA_CCR_MSIZE_8B | DMA_CCR_PSIZE_8B | DMA_CCR_MINC
          STR  R4, [ R1,DMA_CCR2 ]
          LDR  R4, = DMA_CCR_PL_LOW | DMA_CCR_MSIZE_8B | DMA_CCR_PSIZE_8B | DMA_CCR_MINC | DMA_CCR_DIR
          STR  R4, [ R1, DMA_CCR3 ]

     @DMA INTERRUPT ENABLE FOR CIRCULAR COUNTER
          LDR  R0, = NVIC_BASE + NVIC_ISER0
          LSL  R2, R12, #13
          LDR  R1, [ R0 ]
          ORR  R1, R2
          STR  R1, [ R0 ]

          POP  { R0 - R4, LR }
          BX  LR


.GLOBAL   IRQ_DMA1_Channel3
IRQ_DMA1_Channel3:
                    PUSH {r0,r1,lr}
                    SUBS R6, #1 @SUBS R1, #1
                    BNE IRQ_DMA_CH3_exit
                         BBP R0, DMA1_BASE, DMA_CCR3, 0
                         STR R11, [R0, 1*4] @DMA IRQ CH 3 OFF
                         STR R11, [R0] @DMA channel 3 OFF
                         STR R11, [R0, 5*4] @circular off
                    IRQ_DMA_CH3_exit:
                    BBP R0, DMA1_BASE, DMA_IFCR, DMA_IFCR_CGIF3_N
                    STR R12, [r0]
                    POP {r0,r1,lr}
                    BX         LR


