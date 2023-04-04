@.CharSet=CP1251 (Cyrillic)
@GNU AS

@*******************************************************************************************
@*                                      Architecture                                       *
@*******************************************************************************************
@
@    *************************************************
@    *                      SPI                      *
@    *************************************************
@    * EXTERNAL SYMBOLS:                             *
@    *    SPI_VARS - variables SRAM begin            *
@    *    CS_BB_SET - BSRR CS pin bit-banding        *
@    *    CS_BB_RESET - BRR CS pin bit-banding       *
@    *    DC_BB_SET - BSRR DC pin bit-banding        *
@    *    DC_BB_RESET - BRR DC pin bit-banding       *
@    *    RST_BB_SET - BSRR RST pin bit-banding      *
@    *    RST_BB_RESET - BSRR RTS pin bit-banding    *
@    *    TXE_BB - TXE bit-banding                   *
@    *    BSY_BB - BSY bit-banding                   *
@    *    SPI_DR_ADDR - buffer register address      *
@    *************************************************
@    * SPI_Init() - SPI constructor                  *
@    *************************************************
@    * INTERFACE:                                    *
@    *    R7 - SRAM data address                     *
@    *    R8 - TXE bit-banding                       *
@    *    R9 - BSY bit-banding                       *
@    *    R10 - DR address                           *
@    *    <macro> REFRESH_REGISTERS                  *
@    *    <macro> GET_TXE                            *
@    *    <macro> GET_BSY                            *
@    *    <macro> SEND_BYTE                          *
@    *    <macro> SELECT_SLAVE                       *
@    *    <macro> RELEASE_SLAVE                      *
@    *    <macro> IS_COMMAND                         *
@    *    <macro> IS_PARAMETER                       *
@    *    ArraySend(T* buff, int repeats)            *
@    *    .if (DMA_USE == 1)                         *
@    *         DMABulkSend(T* buff, int repeats)     *
@    *    .endif                                     *
@    *  HardResetDisplay()                           *
@    *************************************************
@
@
@
@
@
@
@
@
@
@
@
@


