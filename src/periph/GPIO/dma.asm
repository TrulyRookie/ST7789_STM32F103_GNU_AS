@.CHARSET =CP1251
@GNU AS

.SYNTAX unified   @ синтаксис исходного кода
.THUMB       @ тип используемых инструкций Thumb
.CPU cortex-m3   @ процессор

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
.INCLUDE   "/src/inc/gpio.inc"
.INCLUDE   "/src/inc/rcc.inc"
.INCLUDE   "/src/inc/utils.inc"

.SECTION .bss
.ALIGN ( 2 )
MEM_BUFF_ADDR: .WORD  0
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
          LDR  R1, = ( DMA1 + DMA_CPAR2 )    @ r1 <- pDMA1_CPAR2
          LDR  R2, = SPI1 + SPI_DR    @ r2 <- SPI1_DR_ADDR (address IO SPI register)
          STR  R2, [ R1 ]     @ SPI1_DR_ADDR{r2} -> *pDMA1_CPAR2{[r1]}

          @address TX in periph dma register
          LDR  R1, = ( DMA1 + DMA_CPAR3 )
          STR  R2, [ R1 ]

     @ ch 3 - SPI1 TX, ch 2 - SPI1 RX
          LDR  R3, = ( DMA1 + DMA_CCR2 )
          LDR  R4, = DMA_CCR_PL_LOW | DMA_CCR_MSIZE_8B | DMA_CCR_PSIZE_8B | DMA_CCR_MINC
          STR  R4, [ R3 ]
          LDR  R3, = ( DMA1 + DMA_CCR3 )
          LDR  R4, = DMA_CCR_PL_LOW | DMA_CCR_MSIZE_8B | DMA_CCR_PSIZE_8B | DMA_CCR_MINC | DMA_CCR_DIR
          STR  R4, [ R3 ]

          POP  { R0 - R4, LR }
          BX  LR


