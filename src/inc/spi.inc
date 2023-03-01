@.CHARSET =CP1251 ( Cyrillic )
@GNU AS

@ +--------------------------------------------------------------+
@ |                   Определения SPI 1 и SPI 2                  |
@ |              STM32F100x8B  STM32F103C8B\R8B\V8B              |
@ +--------------------------------------------------------------+


.INCLUDE    "/src/inc/base.inc"

@.ITEM     APB1PERIPH_BASE
.EQU  SPI2_BASE          , APB1PERIPH_BASE + 0x3800
.EQU  SPI2               , PERIPH_BASE + SPI2_BASE
@.end

@.ITEM     APB2PERIPH_BASE
.EQU  SPI1_BASE          , APB2PERIPH_BASE + 0x3000
.EQU  SPI1               , PERIPH_BASE + SPI1_BASE
@.end


@.ITEM     SPI1 SPI1_BASE SPI2 SPI2_BASE SPI3 SPI3_BASE I2S2 I2S2_BASE I2S3 I2S3_BASE
.EQU  SPI_CR1            , 0x00                    @ SPI control register 1 (SPI_CR1)
.EQU  SPI_CR2            , 0x04                    @ SPI control register 2 (SPI_CR2)
.EQU  SPI_SR             , 0X08                    @ SPI status register (SPI_SR)
.EQU  SPI_DR             , 0X0C                    @ SPI data register (SPI_DR)
.EQU  SPI_CRCPR          , 0X10                    @ SPI CRC polynomial register (SPI_CRCPR)
.EQU  SPI_RXCRCR         , 0X14                    @ SPI RX CRC register (SPI_RXCRCR)
.EQU  SPI_TXCRCR         , 0X18                    @ SPI TX CRC register (SPI_TXCRCR)
.EQU  SPI_I2SCFGR        , 0x1C                    @ SPI_I2S configuration register (SPI_I2SCFGR)
.EQU  SPI_I2SPR          , 0X20                    @ SPI_I2S prescaler register (SPI_I2SPR)
@.end

@.ITEM     SPI_CR1
.EQU  SPI_CR1_BIDIMODE   , 1 << 15                 @ Bit 15 BIDIMODE: Bidirectional data mode enable
.EQU  SPI_CR1_BIDIOE     , 1 << 14                 @ Bit 14 BIDIOE: Output enable in bidirectional mode
.EQU  SPI_CR1_CRCEN      , 1 << 13                 @ Bit 13 CRCEN: Hardware CRC calculation enable
.EQU  SPI_CR1_CRCNEXT    , 1 << 12                 @ Bit 12 CRCNEXT: CRC transfer next
.EQU  SPI_CR1_DFF        , 1 << 11                 @ Bit 11 DFF: Data frame format
.EQU  SPI_CR1_DFF_N      , 11
.EQU  SPI_CR1_RXONLY     , 1 << 10                 @ Bit 10 RXONLY: Receive only
.EQU  SPI_CR1_SSM        , 1 << 9                  @ Bit 9 SSM: Software slave management
.EQU  SPI_CR1_SSI        , 1 << 8                  @ Bit 8 SSI: Internal slave select
.EQU  SPI_CR1_LSBFIRST   , 1 << 7                  @ Bit 7 LSBFIRST: Frame format
.EQU  SPI_CR1_SPE        , 1 << 6                  @ Bit 6 SPE: SPI enable
.EQU  SPI_CR1_SPE_N      , 6                       @ SPE bit number
.EQU  SPI_CR1_BR_N       , 3                       @ Bits 5:3 BR[2:0]: Baud rate control
.EQU  SPI_CR1_BR_DIV2    , 0                       @ 000: fPCLK/2
.EQU  SPI_CR1_BR_DIV4    , 1 << 3                  @ 001: fPCLK/4
.EQU  SPI_CR1_BR_DIV8    , 2 << 3                  @ 010: fPCLK/8
.EQU  SPI_CR1_BR_DIV16   , 3 << 3                  @ 011: fPCLK/16
.EQU  SPI_CR1_BR_DIV32   , 4 << 3                  @ 100: fPCLK/32
.EQU  SPI_CR1_BR_DIV64   , 5 << 3                  @ 101: fPCLK/64
.EQU  SPI_CR1_BR_DIV128  , 6 << 3                  @ 110: fPCLK/128
.EQU  SPI_CR1_BR_DIV256  , 7 << 3                  @ 111: fPCLK/256
.EQU  SPI_CR1_MSTR       , 1 << 2                  @ Bit 2 MSTR: Master selection
.EQU  SPI_CR1_CPOL       , 1 << 1                  @ Bit1 CPOL: Clock polarity
.EQU  SPI_CR1_CPHA       , 1                       @ Bit 0 CPHA: Clock phase
@.end

@.ITEM     SPI_CR2
.EQU  SPI_CR2_TXEIE      , 1 << 7                  @ Bit 7 TXEIE: Tx buffer empty interrupt enable
.EQU  SPI_CR2_RXNEIE     , 1 << 6                  @ Bit 6 RXNEIE: RX buffer not empty interrupt enable
.EQU  SPI_CR2_ERRIE      , 1 << 5                  @ Bit 5 ERRIE: Error interrupt enable
.EQU  SPI_CR2_SSOE       , 1 << 2                  @ Bit 2 SSOE: SS output enable
.EQU  SPI_CR2_TXDMAEN_N  , 1                      @ Bit 1 TXDMAEN: Tx buffer DMA enable
.EQU  SPI_CR2_TXDMAEN    , 1 << 1                  @ Bit 1 TXDMAEN: Tx buffer DMA enable
.EQU  SPI_CR2_RXDMAEN_N  , 0
.EQU  SPI_CR2_RXDMAEN    , 1                       @ Bit 0 RXDMAEN: Rx buffer DMA enable
@.end

@.ITEM     SPI_SR
.EQU  SPI_SR_BSY         , 1 << 7                  @ Bit 7 BSY: Busy flag
.EQU  SPI_SR_BSY_N       , 7
.EQU  SPI_SR_OVR         , 1 << 6                  @ Bit 6 OVR: Overrun flag
.EQU  SPI_SR_MODF        , 1 << 5                  @ Bit 5 MODF: Mode fault
.EQU  SPI_SR_CRCERR      , 1 << 4                  @ Bit 4 CRCERR: CRC error flag
.EQU  SPI_SR_UDR         , 1 << 3                  @ Bit 3 UDR: Underrun flag
.EQU  SPI_SR_CHSIDE      , 1 << 2                  @ Bit 2 CHSIDE: Channel side
                                                   @ 0: Channel Left has to be transmitted or has been received
                                                   @ 1: Channel Right has to be transmitted or has been received
                                                   @ Note: This bit is not used for SPI mode and is meaningless in PCM mode.
.EQU  SPI_SR_TXE         , 1 << 1                  @ Bit 1 TXE: Transmit buffer empty
.EQU  SPI_SR_TXE_N       , 1
.EQU  SPI_SR_RXNE        , 1                       @ Bit 0 RXNE: Receive buffer not empty
.EQU  SPI_SR_RXNE_N      , 0
@.end

@.ITEM SPI_I2SCFGR
.EQU SPI_I2SCFGR_I2SMOD  , 1<<11                   @ Bit 11 I2SMOD: I2S mode selection
                                                   @ 0: SPI mode is selected
                                                   @ 1: I2S mode is selected
                                                   @ Note: This bit should be configured when the SPI or I2S is disabled
.EQU SPI_I2SCFGR_I2SE    , 1<<10                   @ Bit 10 I2SE: I2S Enable
                                                   @ 0: I2S peripheral is disabled
                                                   @ 1: I2S peripheral is enabled
                                                   @ Note: This bit is not used in SPI mode.
.EQU SPI_I2SCFGR_I2SCFG_N, 8                       @ Bits 9:8 I2SCFG: I2S configuration mode
.EQU SPI_I2SCFGR_I2SCFG_SLTR, 0                    @ 00: Slave - transmit
.EQU SPI_I2SCFGR_I2SCFG_SLRC, 1                    @ 01: Slave - receive
.EQU SPI_I2SCFGR_I2SCFG_MSTR, 2                    @ 10: Master - transmit
.EQU SPI_I2SCFGR_I2SCFG_MSRC, 3                    @ 11: Master - receive
                                             @ Note: This bit should be configured when the I2S is disabled. It is not used in SPI mode.
.EQU SPI_I2SCFGR_PCMSYNC , 1<<7                    @ Bit 7 PCMSYNC: PCM frame synchronization
                                                   @ 0: Short frame synchronization
                                                   @ 1: Long frame synchronization
                                                   @ Note: This bit has a meaning only if I2SSTD = 11 (PCM standard is used)
                                                   @ It is not used in SPI mode.
.EQU SPI_I2SCFGR_I2SSTD_N , 4                      @ Bits 5:4 I2SSTD: I2S standard selection
.EQU SPI_I2SCFGR_I2SSTD_I2S , 0<<4         @ 00: I2S Philips standard.
.EQU SPI_I2SCFGR_I2SSTD_MSB , 1<<4         @ 01: MSB justified standard (left justified)
.EQU SPI_I2SCFGR_I2SSTD_LSB , 2<<4         @ 10: LSB justified standard (right justified)
.EQU SPI_I2SCFGR_I2SSTD_PCM , 3<<4         @ 11: PCM standard
                                           @ For more details on I2S standards, refer to Section 25.4.2: Supported audio protocols. Not used in SPI mode.
                                           @ Note: For correct operation, these bits should be configured when the I2S is disabled.
.EQU SPI_I2SCFGR_CKPOL, 1<<3                  @ Bit 3 CKPOL: Steady state clock polarity
.EQU SPI_I2SCFGR_DATLEN_N , 1                 @ Bits 2:1 DATLEN: Data length to be transferred
.EQU SPI_I2SCFGR_DATLEN_16, 0                 @ 00: 16-bit data length
.EQU SPI_I2SCFGR_DATLEN_24, 1                 @ 01: 24-bit data length
.EQU SPI_I2SCFGR_DATLEN_32, 2                 @ 10: 32-bit data length
.EQU SPI_I2SCFGR_DATLEN_NA, 3                 @ 11: Not allowed
                                              @ Note: For correct operation, these bits should be configured when the I2S is disabled.
                                              @ This bit is not used in SPI mode.
.EQU SPI_I2SCFGR_CHLEN_32 , 1                @ Bit 0 CHLEN: Channel length (number of bits per audio channel) 0: 16-bit wide, 1: 32-bit wide
@.END

@.ITEM SPI_I2SPR
.EQU SPI_I2SPR_MCKOE       , 1<<9            @ Bit 9 MCKOE: Master clock output enable
                                             @ 0: Master clock output is disabled
                                             @ 1: Master clock output is enabled
                                             @ Note: This bit should be configured when the I2S is disabled. It is used only when the I2S is in master mode.
                                             @ This bit is not used in SPI mode.
.EQU SPI_I2SPR_ODD          , 1<<8           @ Bit 8 ODD: Odd factor for the prescaler
                                             @ 0: real divider value is = I2SDIV *2
                                             @ 1: real divider value is = (I2SDIV * 2)+1
                                             @ Refer to Section 25.4.3: Clock generator. Not used in SPI mode.
                                             @ Note: This bit should be configured when the I2S is disabled. It is used only when the I2S is in master mode.
.EQU SPI_I2SPR_I2SDIV_N     , 0              @ Bits 7:0 I2SDIV: I2S Linear prescaler
                                             @ I2SDIV [7:0] = 0 or I2SDIV [7:0] = 1 are forbidden values.
                                             @ Refer to Section 25.4.3: Clock generator. Not used in SPI mode.
                                             @ Note: These bits should be configured when the I2S is disabled. It is used only when the I2S is in
                                             @ master mode.
@.END


@.ITEM     SPI1_PIN_NUMBERS
.EQU  RST      , 1 << 7                  @ GPIOA reset PIN6
.EQU  DC       , 1 << 6                  @ GPIOB DC PIN0
.EQU  CS       , 1 << 5                  @ GPIOA CS PIN4
@.end

@.ITEM    SPI_SETUP_PARAMETERS
.EQU SPI_DMA_USE, 0
.EQU SPI_CS_GPIO, GPIOA
.EQU SPI_DC_GPIO, GPIOB
.EQU SPI_RST_GPIO, GPIOA

.EQU SPI_CS_NUM, 4
.EQU SPI_DC_NUM, 0
.EQU SPI_RST_NUM, 6

.EQU SPI_SETTINGS_MHBTRSO_8_18_SCKHI_FRONT, SPI_CR1_BIDIMODE|SPI_CR1_BIDIOE|SPI_CR1_SSM|SPI_CR1_SSI|SPI_CR1_BR_DIV4|SPI_CR1_MSTR|SPI_CR1_CPOL
.EQU SPI_SETTINGS_MHBTRSO_8_36_SCKHI_FRONT, SPI_CR1_BIDIMODE|SPI_CR1_BIDIOE|SPI_CR1_SSM|SPI_CR1_SSI|SPI_CR1_BR_DIV2|SPI_CR1_MSTR|SPI_CR1_CPOL
@.END

