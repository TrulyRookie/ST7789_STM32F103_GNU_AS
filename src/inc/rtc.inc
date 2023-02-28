@.CHARSET =CP1251 ( Cyrillic )
@GNU AS


@ +---------------------------------------------------------------+
@ |                         Определения RTC                       |
@ |                  STM32F100xxx   STM32F103xxx                  |
@ +---------------------------------------------------------------+

.include "/src/inc/base.inc"

@.ITEM     APB1PERIPH_BASE
.EQU  RTC_BASE       , APB1PERIPH_BASE + 0x2800
.EQU  RTC            , PERIPH_BASE + RTC_BASE
@.end

@.ITEM     RTC RTC_BASE
.EQU  RTC_CRH        , 0x00                        @ RTC control register high (RTC_CRH)
.EQU  RTC_CRL        , 0x04                        @ RTC control register low (RTC_CRL)
.EQU  RTC_PRLH       , 0x08                        @ RTC prescaler load register high (RTC_PRLH)
.EQU  RTC_PRLL       , 0X0C                        @ RTC prescaler load register low (RTC_PRLL)
.EQU  RTC_DIVH       , 0X10                        @ RTC prescaler divider register high (RTC_DIVH)
.EQU  RTC_DIVL       , 0X14                        @ RTC prescaler divider register low (RTC_DIVL)
.EQU  RTC_CNTH       , 0X18                        @ RTC counter register high (RTC_CNTH)
.EQU  RTC_CNTL       , 0X1C                        @ RTC counter register low (RTC_CNTL)
.EQU  RTC_ALRH       , 0X20                        @ RTC alarm register high (RTC_ALRH)
.EQU  RTC_ALRL       , 0X24                        @ RTC alarm register low (RTC_ALRL)
@.end

@.ITEM     RTC_CRH
.EQU  RTC_CRH_OWIE   , 1 << 2                      @ Bit 2 OWIE: Overflow interrupt enable
.EQU  RTC_CRH_ALRIE  , 1 << 1                      @ Bit 1 ALRIE: Alarm interrupt enable
.EQU  RTC_CRH_SECIE  , 1                           @ Bit 0 SECIE: Second interrupt enable
@.end

@.ITEM     RTC_CRL
.EQU  RTC_CRL_RTOFF  , 1 << 5                      @ Bit 5 RTOFF: RTC operation OFF
.EQU  RTC_CRL_CNF    , 1 << 4                      @ Bit 4 CNF: Configuration flag
.EQU  RTC_CRL_RSF    , 1 << 3                      @ Bit 3 RSF: Registers synchronized flag
.EQU  RTC_CRL_OWF    , 1 << 2                      @ Bit 2 OWF: Overflow flag
.EQU  RTC_CRL_ALRF   , 1 << 1                      @ Bit 1 ALRF: Alarm flag
.EQU  RTC_CRL_SECF   , 1                           @ Bit 0 SECF: Second flag
@.end

@.ITEM     RTC_PRLH
.EQU  RTC_PRLH_PRL_N , 0                           @ Bits 3:0 PRL[19:16]: RTC prescaler reload value high
@.end

@.ITEM     RTC_PRLL
.EQU  RTC_PRLL_RSTVAL, 0x8000                      @ Reset value
.EQU  RTC_PRLL_PRL_N , 0                           @ Bits 15:0 PRL[15:0]: RTC prescaler reload value low
@.end

@.ITEM     RTC_DIVH
.EQU  RTC_DIVH_DIV_N , 0                           @ Bits 3:0 RTC_DIV[19:16]: RTC clock divider high
@.end

@.ITEM     RTC_DIVL
.EQU  RTC_DIVL_RSTVAL, 0x8000                      @ Reset value
.EQU  RTC_DIVL_DIV_N , 0                           @ Bits 15:0 RTC_DIV[15:0]: RTC clock divider low
@.end

