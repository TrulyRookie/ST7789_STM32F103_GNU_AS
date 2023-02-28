@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор

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
.include "/src/inc/dma.inc"
.include "/src/inc/spi.inc"
.include "/src/inc/gpio.inc"
.include "/src/inc/rcc.inc"
.include "/src/inc/utils.inc"

.global DMA1_CNDTR2_ADDR
.global DMA1_CNDTR3_ADDR
.global DMA1_CMAR2_ADDR       @
.global DMA1_CMAR3_ADDR       @
.global DMA1_CH2_EN_BB        @
.global DMA1_CH3_EN_BB        @
.global DMA1_CH2_CIRC_BB      @
.global DMA1_CH3_CIRC_BB      @
.global DMA1_CH2_TCIE_BB      @
.global DMA1_CH3_TCIE_BB      @
.global DMA1_CH3_CTCIF3_BB    @
.global DMA1_CH3_TCIF3_BB     @

.section .bss
     .align(2)
.global DMA_CH2_SRAM_BASE
.global DMA_CH3_SRAM_BASE
.global DMA_SRAM_BASE
DMA_SRAM_BASE:
     MEM_BUFF_ADDR: .word 0
DMA_CH2_SRAM_BASE:
@*********Chanel 2 SPI RX***************************************
     DMA1_CNDTR2_ADDR:  .word 0  @ +0   counter
     DMA1_CMAR2_ADDR:   .word 0  @ +4   memory pointer
     DMA1_CH2_EN_BB:    .word 0  @ +8   chanel enable bit
     DMA1_CH2_CIRC_BB:  .word 0  @ +12  circular mode switcher bit
     DMA1_CH2_TCIE_BB:  .word 0  @ +16  transfer complete interrupt switcher bit
     DMA1_CH3_CTCIF2_BB:.word 0 @ +20
     DMA1_CH3_TCIF2_BB: .word 0 @ +24
@*********Chanel 3 SPI TX***************************************
DMA_CH3_SRAM_BASE:
     DMA1_CNDTR3_ADDR:  .word 0  @ +0   counter
     DMA1_CMAR3_ADDR:   .word 0  @ +4
     DMA1_CH3_EN_BB:    .word 0  @ +8
     DMA1_CH3_CIRC_BB:  .word 0  @ +12
     DMA1_CH3_TCIE_BB:  .word 0  @ +16
     DMA1_CH3_CTCIF3_BB:.word 0  @ +20
     DMA1_CH3_TCIF3_BB: .word 0  @ +24
.section .asmcode

.global DMA_Init

DMA_Init:
     PUSH {r0-r4,lr}
     @ DMA1 clock enable
     BBP r1, RCC_BASE, RCC_AHBENR, RCC_AHBENR_DMA1EN_N  @ bit-banding DMA1 clock enable bit
     MOV r2, #1                                         @ r2 <- 1
     STR r2, [r1]                                       @ r2 -> [r1] enable DMA1
     @ DMA ch2 and ch3 setup
     @address RX in periph dma register
     LDR r1, =(DMA1+DMA_CPAR2)                          @ r1 <- pDMA1_CPAR2
     LDR r2, =SPI1+SPI_DR                              @ r2 <- SPI1_DR_ADDR (address IO SPI register)
     STR r2, [r1]                    @ SPI1_DR_ADDR{r2} -> *pDMA1_CPAR2{[r1]}

     @address TX in periph dma register
     LDR r1, =(DMA1+DMA_CPAR3)
     STR r2, [r1]
     LDR r0, =DMA_CH2_SRAM_BASE
     LDR r1, =DMA_CH3_SRAM_BASE

     BBP r1, DMA1_BASE, DMA_CCR2, 0                     @ 2 ch EN bit band address
     LDR r2,=DMA1_CH2_EN_BB                            @ r2 <- pDMA1_CH2_EN_BB
     STR r1, [r2]
                                       @ r1 -> *pDMA1_CH2_EN_BB{[r2]}
     BBP r1, DMA1_BASE, DMA_CCR2, 5
     LDR r2, =DMA1_CH2_CIRC_BB
     STR r1, [r2]

     BBP r1, DMA1_BASE, DMA_CCR2, 1
     LDR r2, =DMA1_CH2_TCIE_BB
     STR r1, [r2]

     BBP r1, DMA1_BASE, DMA_CCR3, 0                     @ 3 ch EN bit band config
     LDR r2, =DMA1_CH3_EN_BB
     STR r1, [r2]

     BBP r1, DMA1_BASE, DMA_CCR3, 5
     LDR r2, =DMA1_CH3_CIRC_BB
     STR r1, [r2]

     BBP r1, DMA1_BASE, DMA_CCR3, 1
     LDR r2, =DMA1_CH3_TCIE_BB
     STR r1, [r2]

     LDR r1, =(DMA1+DMA_CNDTR2)
     LDR r2, =DMA1_CNDTR2_ADDR
     MOV r9, r2
     STR r1, [r2]
     LDR r1, =(DMA1+DMA_CNDTR3)
     LDR r2, =DMA1_CNDTR3_ADDR
     STR r1, [r2]
     LDR r1, =(DMA1+DMA_CMAR2)
     LDR r2, =DMA1_CMAR2_ADDR
     STR r1, [r2]
     LDR r1, =(DMA1+DMA_CMAR3)
     LDR r2, =DMA1_CMAR3_ADDR
     STR r1, [r2]
     BBP r1, DMA1_BASE, DMA_IFCR, 9
     LDR r2, =DMA1_CH3_CTCIF3_BB
     STR r1, [r2]
     BBP r1, DMA1_BASE, DMA_ISR, 9
     LDR r2, =DMA1_CH3_TCIF3_BB
     STR r1, [r2]
     @ ch 3 - SPI1 TX, ch 2 - SPI1 RX
     @ ch3 setup half word 0x0090 (8bit mem to periph, memory increment, non circular, not enabled)
     @ ch2 setup half word 0x0080 (8bit periph to mem, memory increment, non circular, not enabled)
     LDR r3, =(DMA1+DMA_CCR2)
     MOVW r4, #0x0080
     STR r4, [r3]
     LDR r3, =(DMA1+DMA_CCR3)
     MOVW r4, #0x0090
     STR r4, [r3]


     pop {r0-r4,lr}
     BX LR


