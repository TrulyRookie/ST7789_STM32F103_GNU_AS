@.CharSet=CP1251 (Cyrillic)
@GNU AS

@ +------------------------------------------------------------------+
@ |                          Определения DMA                         |
@ |                          STM32F103x468B                          |
@ +------------------------------------------------------------------+

.include "/src/inc/base.inc"
@.ITEM     AHBPERIPH_BASE
.EQU  DMA1_BASE      , AHBPERIPH_BASE
.EQU  DMA1           , PERIPH_BASE + DMA1_BASE
@.END

@.ITEM     DMA1 DMA1_BASE DMA2 DMA2_BASE
.EQU  DMA_ISR        , 0x000                       @ DMA interrupt status register (DMA_ISR)
.EQU  DMA_IFCR       , 0x004                       @ DMA interrupt flag clear register (DMA_IFCR)
.EQU  DMA_CCR1       , 0x008                       @ DMA channel 1 configuration register (DMA_CCRx)
.EQU  DMA_CNDTR1     , 0x00C                       @ DMA channel 1 number of data register (DMA_CNDTRx)
.EQU  DMA_CPAR1      , 0x010                       @ DMA channel 1 peripheral address register (DMA_CPARx)
.EQU  DMA_CMAR1      , 0x014                       @ DMA channel 1 memory address register (DMA_CMARx)
.EQU  DMA_CCR2       , 0x01C                       @ DMA channel 2 configuration register (DMA_CCRx)
.EQU  DMA_CNDTR2     , 0x020                       @ DMA channel 2 number of data register (DMA_CNDTRx)
.EQU  DMA_CPAR2      , 0x024                       @ DMA channel 2 peripheral address register (DMA_CPARx)
.EQU  DMA_CMAR2      , 0x028                       @ DMA channel 2 memory address register (DMA_CMARx)
.EQU  DMA_CCR3       , 0x030                       @ DMA channel 3 configuration register (DMA_CCRx)
.EQU  DMA_CNDTR3     , 0x034                       @ DMA channel 3 number of data register (DMA_CNDTRx)
.EQU  DMA_CPAR3      , 0x038                       @ DMA channel 3 peripheral address register (DMA_CPARx)
.EQU  DMA_CMAR3      , 0x03C                       @ DMA channel 3 memory address register (DMA_CMARx)
.EQU  DMA_CCR4       , 0x044                       @ DMA channel 4 configuration register (DMA_CCRx)
.EQU  DMA_CNDTR4     , 0x048                       @ DMA channel 4 number of data register (DMA_CNDTRx)
.EQU  DMA_CPAR4      , 0x04C                       @ DMA channel 4 peripheral address register (DMA_CPARx)
.EQU  DMA_CMAR4      , 0x050                       @ DMA channel 4 memory address register (DMA_CMARx)
.EQU  DMA_CCR5       , 0x058                       @ DMA channel 5 configuration register (DMA_CCRx)
.EQU  DMA_CNDTR5     , 0x05C                       @ DMA channel 5 number of data register (DMA_CNDTRx)
.EQU  DMA_CPAR5      , 0x060                       @ DMA channel 5 peripheral address register (DMA_CPARx)
.EQU  DMA_CMAR5      , 0x064                       @ DMA channel 5 memory address register (DMA_CMARx)
.EQU  DMA_CCR6       , 0x06C                       @ DMA channel 6 configuration register (DMA_CCRx)
.EQU  DMA_CNDTR6     , 0x070                       @ DMA channel 6 number of data register (DMA_CNDTRx)
.EQU  DMA_CPAR6      , 0x074                       @ DMA channel 6 peripheral address register (DMA_CPARx)
.EQU  DMA_CMAR6      , 0x078                       @ DMA channel 6 memory address register (DMA_CMARx)
.EQU  DMA_CCR7       , 0x080                       @ DMA channel 7 configuration register (DMA_CCRx)
.EQU  DMA_CNDTR7     , 0x084                       @ DMA channel 7 number of data register (DMA_CNDTRx)
.EQU  DMA_CPAR7      , 0x088                       @ DMA channel 7 peripheral address register (DMA_CPARx)
.EQU  DMA_CMAR7      , 0x08C                       @ DMA channel 7 memory address register (DMA_CMARx)
@.END

@.ITEM     DMA_ISR
.EQU  DMA_ISR_TEIF_NOTE, 0                         @ No transfer error (TE) on channel x
.EQU  DMA_ISR_TEIF_TE, 1                           @ A transfer error (TE) occurred on channel x
.EQU  DMA_ISR_HTIF_NOHT, 0                         @ No half transfer (HT) event on channel x
.EQU  DMA_ISR_HTIF_HT, 1                           @ A half transfer (HT) event occurred on channel x
.EQU  DMA_ISR_TCIF_NOTC, 0                         @ No transfer complete (TC) event on channel x
.EQU  DMA_ISR_TCIF_TC, 1                           @ A transfer complete (TC) event occurred on channel x
.EQU  DMA_ISR_GIF_NO , 0                           @ No TE, HT or TC event on channel x
.EQU  DMA_ISR_GIF_TE_HT_TC, 1                      @ A TE, HT or TC event occurred on channel x
.EQU  DMA_ISR_TEIF1_N, 3                           @ TEIF1: Channel 1 transfer error flag
.EQU  DMA_ISR_HTIF1_N, 2                           @ HTIF1: Channel 1 half transfer flag
.EQU  DMA_ISR_TCIF1_N, 1                           @ TCIF1: Channel 1 transfer complete flag
.EQU  DMA_ISR_GIF1_N , 0                           @ GIF1: Channel 1 global interrupt flag
.EQU  DMA_ISR_TEIF2_N, 7                           @ TEIF2: Channel 2 transfer error flag
.EQU  DMA_ISR_HTIF2_N, 6                           @ HTIF2: Channel 2 half transfer flag
.EQU  DMA_ISR_TCIF2_N, 5                           @ TCIF2: Channel 2 transfer complete flag
.EQU  DMA_ISR_GIF2_N , 4                           @ GIF2: Channel 2 global interrupt flag
.EQU  DMA_ISR_TEIF3_N, 11                          @ TEIF3: Channel 3 transfer error flag
.EQU  DMA_ISR_HTIF3_N, 10                          @ HTIF3: Channel 3 half transfer flag
.EQU  DMA_ISR_TCIF3_N, 9                           @ TCIF3: Channel 3 transfer complete flag
.EQU  DMA_ISR_TCIF3 , 1 << 9                       @ TCIF3: Channel 3 transfer complete flag
.EQU  DMA_ISR_GIF3_N , 8                           @ GIF3: Channel 3 global interrupt flag
.EQU  DMA_ISR_TEIF4_N, 15                          @ TEIF4: Channel 4 transfer error flag
.EQU  DMA_ISR_HTIF4_N, 14                          @ HTIF4: Channel 4 half transfer flag
.EQU  DMA_ISR_TCIF4_N, 13                          @ TCIF4: Channel 4 transfer complete flag
.EQU  DMA_ISR_GIF4_N , 12                          @ GIF4: Channel 4 global interrupt flag
.EQU  DMA_ISR_TEIF5_N, 19                          @ TEIF5: Channel 5 transfer error flag
.EQU  DMA_ISR_HTIF5_N, 18                          @ HTIF5: Channel 5 half transfer flag
.EQU  DMA_ISR_TCIF5_N, 17                          @ TCIF5: Channel 5 transfer complete flag
.EQU  DMA_ISR_GIF5_N , 16                          @ GIF5: Channel 5 global interrupt flag
.EQU  DMA_ISR_TEIF6_N, 23                          @ TEIF6: Channel 6 transfer error flag
.EQU  DMA_ISR_HTIF6_N, 22                          @ HTIF6: Channel 6 half transfer flag
.EQU  DMA_ISR_TCIF6_N, 21                          @ TCIF6: Channel 6 transfer complete flag
.EQU  DMA_ISR_GIF6_N , 20                          @ GIF6: Channel 6 global interrupt flag
.EQU  DMA_ISR_TEIF7_N, 27                          @ TEIF7: Channel 7 transfer error flag
.EQU  DMA_ISR_HTIF7_N, 26                          @ HTIF7: Channel 7 half transfer flag
.EQU  DMA_ISR_TCIF7_N, 25                          @ TCIF7: Channel 7 transfer complete flag
.EQU  DMA_ISR_GIF7_N , 24                          @ GIF7: Channel 7 global interrupt flag
@.END

@.ITEM     DMA_IFCR
.EQU  DMA_IFCR_CTEIF_NOEF, 0                       @ No effect
.EQU  DMA_IFCR_CTEIF_CLR, 1                        @ Clears the corresponding TEIF flag in the DMA_ISR register
.EQU  DMA_IFCR_CHTIF_NOEF, 0                       @ No effect
.EQU  DMA_IFCR_CHTIF_CLR, 1                        @ Clears the corresponding HTIF flag in the DMA_ISR register
.EQU  DMA_IFCR_CTCIF_NOEF, 0                       @ No effect
.EQU  DMA_IFCR_CTCIF_CLR, 1                        @ Clears the corresponding TCIF flag in the DMA_ISR register
.EQU  DMA_IFCR_CGIF_NOEF, 0                        @ No effect
.EQU  DMA_IFCR_CGIF_CLR, 1                         @ Clears the GIF, TEIF, HTIF and TCIF flags in the DMA_ISR register
.EQU  DMA_IFCR_CTEIF1_N, 3                         @ CTEIF1: Channel 1 transfer error clear
.EQU  DMA_IFCR_CHTIF1_N, 2                         @ CHTIF1: Channel 1 half transfer clear
.EQU  DMA_IFCR_CTCIF1_N, 1                         @ CTCIF1: Channel 1 transfer complete clear
.EQU  DMA_IFCR_CGIF1_N, 0                          @ CGIF1: Channel 1 global interrupt clear
.EQU  DMA_IFCR_CTEIF2_N, 7                         @ CTEIF2: Channel 2 transfer error clear
.EQU  DMA_IFCR_CHTIF2_N, 6                         @ CHTIF2: Channel 2 half transfer clear
.EQU  DMA_IFCR_CTCIF2_N, 5                         @ CTCIF2: Channel 2 transfer complete clear
.EQU  DMA_IFCR_CGIF2_N, 4                          @ CGIF2: Channel 2 global interrupt clear
.EQU  DMA_IFCR_CTEIF3_N, 11                        @ CTEIF3: Channel 3 transfer error clear
.EQU  DMA_IFCR_CHTIF3_N, 10                        @ CHTIF3: Channel 3 half transfer clear
.EQU  DMA_IFCR_CTCIF3_N, 9                         @ CTCIF3: Channel 3 transfer complete clear
.EQU  DMA_IFCR_CGIF3_N, 8                          @ CGIF3: Channel 3 global interrupt clear
.EQU  DMA_IFCR_CTEIF4_N, 15                        @ CTEIF4: Channel 4 transfer error clear
.EQU  DMA_IFCR_CHTIF4_N, 14                        @ CHTIF4: Channel 4 half transfer clear
.EQU  DMA_IFCR_CTCIF4_N, 13                        @ CTCIF4: Channel 4 transfer complete clear
.EQU  DMA_IFCR_CGIF4_N, 12                         @ CGIF4: Channel 4 global interrupt clear
.EQU  DMA_IFCR_CTEIF5_N, 19                        @ CTEIF5: Channel 5 transfer error clear
.EQU  DMA_IFCR_CHTIF5_N, 18                        @ CHTIF5: Channel 5 half transfer clear
.EQU  DMA_IFCR_CTCIF5_N, 17                        @ CTCIF5: Channel 5 transfer complete clear
.EQU  DMA_IFCR_CGIF5_N, 16                         @ CGIF5: Channel 5 global interrupt clear
.EQU  DMA_IFCR_CTEIF6_N, 23                        @ CTEIF6: Channel 6 transfer error clear
.EQU  DMA_IFCR_CHTIF6_N, 22                        @ CHTIF6: Channel 6 half transfer clear
.EQU  DMA_IFCR_CTCIF6_N, 21                        @ CTCIF6: Channel 6 transfer complete clear
.EQU  DMA_IFCR_CGIF6_N, 20                         @ CGIF6: Channel 6 global interrupt clear
.EQU  DMA_IFCR_CTEIF7_N, 27                        @ CTEIF7: Channel 7 transfer error clear
.EQU  DMA_IFCR_CHTIF7_N, 26                        @ CHTIF7: Channel 7 half transfer clear
.EQU  DMA_IFCR_CTCIF7_N, 25                        @ CTCIF7: Channel 7 transfer complete clear
.EQU  DMA_IFCR_CGIF7_N, 24                         @ CGIF7: Channel 7 global interrupt clear
@.END

@.ITEM     DMA_CCR1 DMA_CCR2 DMA_CCR3 DMA_CCR4 DMA_CCR5 DMA_CCR6 DMA_CCR7
.EQU  DMA_CCR_MEM2MEM, 1 << 14                     @ Bit 14 MEM2MEM: Memory to memory mode
.EQU  DMA_CCR_PL_N   , 12                          @ Bits 13:12 PL[1:0]: Channel priority level
.EQU  DMA_CCR_PL_LOW , 0                           @ Low
.EQU  DMA_CCR_PL_MEDIUM, 1 << 12                   @ Medium
.EQU  DMA_CCR_PL_HIGH, 2 << 12                     @ High
.EQU  DMA_CCR_PL_VERYHIGH, 3 << 12                 @ Very High
.EQU  DMA_CCR_MSIZE_N, 10                          @ Bits 11:10 MSIZE[1:0]: Memory size
.EQU  DMA_CCR_MSIZE_8B, 0                          @ 8 Bit
.EQU  DMA_CCR_MSIZE_16B, 1 << 10                   @ 16 Bit
.EQU  DMA_CCR_MSIZE_32B, 2 << 10                   @ 32 Bit
.EQU  DMA_CCR_PSIZE_N, 8                           @ Bits 11:10 MSIZE[1:0]: Memory size
.EQU  DMA_CCR_PSIZE_8B, 0                          @ 8 Bit
.EQU  DMA_CCR_PSIZE_16B, 1 << 8                    @ 16 Bit
.EQU  DMA_CCR_PSIZE_32B, 2 << 8                    @ 32 Bit
.EQU  DMA_CCR_MINC   , 1 << 7                      @ Bit 7 MINC: Memory increment mode
.EQU  DMA_CCR_PINC   , 1 << 6                      @ Bit 6 PINC: Peripheral increment mode
.EQU  DMA_CCR_CIRC   , 1 << 5                      @ Bit 5 CIRC: Circular mode
.EQU  DMA_CCR_DIR    , 1 << 4                      @ Bit 4 DIR: Data transfer direction
.EQU  DMA_CCR_TEIE   , 1 << 3                      @ Bit 3 TEIE: Transfer error interrupt enable
.EQU  DMA_CCR_HTIE   , 1 << 2                      @ Bit 2 HTIE: Half transfer interrupt enable
.EQU  DMA_CCR_TCIE   , 1 << 1                      @ Bit 1 TCIE: Transfer complete interrupt enable
.EQU  DMA_CCR_EN_N  , 0                            @ Bit 0 EN: Channel enable, номер бита
.EQU  DMA_CCR_EN    , 1                            @ Bit 0 EN: Channel enable
@.END


