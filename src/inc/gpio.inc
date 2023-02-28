@.CHARSET =CP1251 ( Cyrillic )
@GNU AS

@.desc type=module
@ +-------------------------------------------------------------------+
@ |                       Определения GPIO + AFIO                     |
@ |                            STM32F103Cxx                           |
@ +-------------------------------------------------------------------+
@.enddesc

.INCLUDE    "/src/inc/base.inc"

@.ITEM     APB2PERIPH_BASE
.EQU  GPIOA_BASE         , APB2PERIPH_BASE + 0x0800
.EQU  GPIOB_BASE         , APB2PERIPH_BASE + 0x0C00
.EQU  GPIOC_BASE         , APB2PERIPH_BASE + 0x1000
.EQU  GPIOD_BASE         , APB2PERIPH_BASE + 0x1400
.EQU  GPIOA              , PERIPH_BASE + GPIOA_BASE
.EQU  GPIOB              , PERIPH_BASE + GPIOB_BASE
.EQU  GPIOC              , PERIPH_BASE + GPIOC_BASE
.EQU  GPIOD              , PERIPH_BASE + GPIOD_BASE
.EQU  AFIO_BASE          , APB2PERIPH_BASE
.EQU  AFIO               , PERIPH_BASE + APB2PERIPH_BASE
@.end

@.ITEM     GPIOA GPIOB GPIOC GPIOD GPIOE GPIOA_BASE GPIOB_BASE GPIOC_BASE GPIOD_BASE GPIOE_BASE GPIOF_BASE GPIOG_BASE
.EQU  GPIO_CRL           , 0x00                    @ Port configuration register low (GPIOx_CRL)
.EQU  GPIO_CRH           , 0x04                    @ Port configuration register high (GPIOx_CRH)
.EQU  GPIO_IDR           , 0x08                    @ Port input data register (GPIOx_IDR)
.EQU  GPIO_ODR           , 0x0C                    @ Port output data register (GPIOx_ODR)
.EQU  GPIO_BSRR          , 0x10                    @ Port bi t se t/reset register (GPIOx_BSRR)
.EQU  GPIO_BRR           , 0x14                    @ Port bit reset register (GPIOx_BRR)
.EQU  GPIO_LCKR          , 0x18                    @ Port configuration lock register (GPIOx_LCKR)

@.ITEM     AFIO_BASE
.EQU  AFIO_EVCR          , 0x00                    @ Event co ntrol re gister (AFIO_EVCR)
.EQU  AFIO_MAPR          , 0x04                    @ AF remap and debug I/O configuration register (AFIO_MAPR)
.EQU  AFIO_EXTICR1       , 0x08                    @ External interrupt configuration register 1 (AFIO_EXTICR1)
.EQU  AFIO_EXTICR2       , 0x0C                    @ External interrupt configuration register 2 (AFIO_EXTICR2)
.EQU  AFIO_EXTICR3       , 0x10                    @ External interrupt configuration register 3 (AFIO_EXTICR3)
.EQU  AFIO_EXTICR4       , 0x14                    @ External interrupt configuration register 4 (AFIO_EXTICR4)
.EQU  AFIO_MAPR2         , 0x1C                    @ AF remap and debug I/O configuration register (AFIO_MAPR2)

@.ITEM     GPIO_CRL
.EQU  GPIO_CRL_RSTVALUE  , 0x44444444              @ значение регистра по умолчанию
.EQU  GPIO_CRL_MODE0_N   , 0                       @ 0:1  Pin 0 Port mode bits
.EQU  GPIO_CRL_MODE1_N   , 4                       @ 4:5  Pin 1 Port mode bits
.EQU  GPIO_CRL_MODE2_N   , 8                       @ 8:9  Pin 2 Port mode bits
.EQU  GPIO_CRL_MODE3_N   , 12                      @ 12:13  Pin 3 Port mode bits
.EQU  GPIO_CRL_MODE4_N   , 16                      @ 16:17  Pin 4 Port mode bits
.EQU  GPIO_CRL_MODE5_N   , 20                      @ 20:21  Pin 5 Port mode bits
.EQU  GPIO_CRL_MODE6_N   , 24                      @ 24:25  Pin 6 Port mode bits
.EQU  GPIO_CRL_MODE7_N   , 28                      @ 28:29  Pin 7 Port mode bits
.EQU  GPIO_CRL_CNF0_N    , 2                       @ 2:3  Pin 0 Port configuration bits
.EQU  GPIO_CRL_CNF1_N    , 6                       @ 6:7  Pin 1 Port configuration bits
.EQU  GPIO_CRL_CNF2_N    , 10                      @ 10:11  Pin 2 Port configuration bits
.EQU  GPIO_CRL_CNF3_N    , 14                      @ 14:15  Pin 3 Port configuration bits
.EQU  GPIO_CRL_CNF4_N    , 18                      @ 18:19  Pin 4 Port configuration bits
.EQU  GPIO_CRL_CNF5_N    , 22                      @ 22:23  Pin 5 Port configuration bits
.EQU  GPIO_CRL_CNF6_N    , 26                      @ 26:27  Pin 6 Port configuration bits
.EQU  GPIO_CRL_CNF7_N    , 30                      @ 30:31  Pin 7 Port configuration bits

@.ITEM     GPIO_CRH
.EQU  GPIO_CRH_RSTVALUE  , 0x44444444              @ значение регистра по умолчанию
.EQU  GPIO_CRH_MODE8_N   , 0                       @ 0:1  Pin 8 Port mode bits
.EQU  GPIO_CRH_MODE9_N   , 4                       @ 4:5  Pin 9 Port mode bits
.EQU  GPIO_CRH_MODE10_N  , 8                       @ 8:9  Pin 10 Port mode bits
.EQU  GPIO_CRH_MODE11_N  , 12                      @ 12:13  Pin 11 Port mode bits
.EQU  GPIO_CRH_MODE12_N  , 16                      @ 16:17  Pin 12 Port mode bits
.EQU  GPIO_CRH_MODE13_N  , 20                      @ 20:21  Pin 13 Port mode bits
.EQU  GPIO_CRH_MODE14_N  , 24                      @ 24:25  Pin 14 Port mode bits
.EQU  GPIO_CRH_MODE15_N  , 28                      @ 28:29  Pin 15 Port mode bits
.EQU  GPIO_CRH_CNF8_N    , 2                       @ 2:3  Pin 8 Port configuration bits
.EQU  GPIO_CRH_CNF9_N    , 6                       @ 6:7  Pin 9 Port configuration bits
.EQU  GPIO_CRH_CNF10_N   , 10                      @ 10:11  Pin 10 Port configuration bits
.EQU  GPIO_CRH_CNF11_N   , 14                      @ 14:15  Pin 11 Port configuration bits
.EQU  GPIO_CRH_CNF12_N   , 18                      @ 18:19  Pin 12 Port configuration bits
.EQU  GPIO_CRH_CNF13_N   , 22                      @ 22:23  Pin 13 Port configuration bits
.EQU  GPIO_CRH_CNF14_N   , 26                      @ 26:27  Pin 14 Port configuration bits
.EQU  GPIO_CRH_CNF15_N   , 30                      @ 30:31  Pin 15 Port configuration bits

@.ITEM     GPIO_CRL_MODE0_N GPIO_CRL_MODE1_N GPIO_CRL_MODE2_N GPIO_CRL_MODE3_N GPIO_CRL_MODE4_N GPIO_CRL_MODE5_N GPIO_CRL_MODE6_N GPIO_CRL_MODE7_N GPIO_CRL_MODE8_N GPIO_CRL_MODE9_N GPIO_CRL_MODE10_N GPIO_CRL_MODE11_N GPIO_CRL_MODE12_N GPIO_CRL_MODE13_N GPIO_CRL_MODE14_N GPIO_CRL_MODE15_N
.EQU  GPIO_MODE_INPUT    , 0                       @ Input mode (reset state)
.EQU  GPIO_MODE_OUT10    , 1                       @ Output mode speed 10 MHz
.EQU  GPIO_MODE_OUT2     , 2                       @ Output mode speed 2 MHz
.EQU  GPIO_MODE_OUT50    , 3                       @ Output mode speed 50 MHz

@.ITEM     GPIO_CRL_CNF0_N GPIO_CRL_CNF1_N GPIO_CRL_CNF2_N GPIO_CRL_CNF3_N GPIO_CRL_CNF4_N GPIO_CRL_CNF5_N  GPIO_CRL_CNF6_N GPIO_CRL_CNF7_N GPIO_CRL_CNF8_N GPIO_CRL_CNF9_N GPIO_CRL_CNF10_N GPIO_CRL_CNF11_N GPIO_CRL_CNF12_N GPIO_CRL_CNF13_N GPIO_CRL_CNF14_N GPIO_CRL_CNF15_N
.EQU  GPIO_CNF_INP_ANALOG, 0                       @ Input mode: Analog mode
.EQU  GPIO_CNF_INP_FLOAT , 1                       @ Input mode: Floating input (reset state)
.EQU  GPIO_CNF_INP_PULLUP, 2                       @ Input mode: Input with pull-up/pull-down
.EQU  GPIO_CNF_OUT_PP    , 0                       @ Output mode: output Push-pull
.EQU  GPIO_CNF_OUT_OD    , 1                       @ Output mode: output Open Drain
.EQU  GPIO_CNF_OUT_AFPP  , 2                       @ Output mode: Alternate function output Push-pull
.EQU  GPIO_CNF_OUT_AFOD  , 3                       @ Output mode: Alternate function output Open Drain

@.ITEM     GPIO_LCKR
.EQU  GPIO_LCKR_LCKK     , 0x00010000              @ Lock key

@.ITEM     AFIO_EVCR
.EQU  AFIO_EVCR_EVOE     , 0x80                    @ Event output enable
.EQU  AFIO_EVCR_PORT_N   , 4                       @ 4:6 Selected by port
.EQU  AFIO_EVCR_PIN_N    , 0                       @ 0:3 Pin num selected

@.ITEM     AFIO_MAPR
.EQU  AFIO_MAPR_SWJ_CFG_N, 24                      @ SWJ_CFG[2:0]: Serial wire JTAG configuration
.EQU  AFIO_MAPR_SWJ_RST  , 0                       @ Full SWJ (JTAG-DP + SW-DP): Reset State
.EQU  AFIO_MAPR_SWJ_NJTRST, 1                      @ Full SWJ (JTAG-DP + SW-DP) but without NJTRST
.EQU  AFIO_MAPR_SWJ_SWD_EN, 2                      @ JTAG-DP Disabled and SW-DP Enabled
.EQU  AFIO_MAPR_SWJ_SWD_DIS, 4                     @ JTAG-DP Disabled and SW-DP Disabled
.EQU  AFIO_MAPR_PD01_REMAP, 1 << 15                @ PD0 remapped on OSC_IN, PD1 remapped on OSC_OUT
.EQU  AFIO_MAPR_TIM4_REMAP, 1 << 12                @ Full remap (TIM4_CH1/PD12, TIM4_CH2/PD13, TIM4_CH3/PD14, TIM4_CH4/PD15)
.EQU  AFIO_MAPR_TIM3_REMAP_N, 10                   @ TIM3 remapping
.EQU  AFIO_MAPR_TIM3_NO_REMAP, 0                   @ No remap (CH1/PA6, CH2/PA7, CH3/PB0, CH4/PB1)
.EQU  AFIO_MAPR_TIM3_PART_REMAP, 2 << 10           @ Partial remap (CH1/PB4, CH2/PB5, CH3/PB0, CH4/PB1)
.EQU  AFIO_MAPR_TIM3_FULL_REMAP, 3 << 10           @ Full remap (CH1/PC6, CH2/PC7, CH3/PC8, CH4/PC9)
.EQU  AFIO_MAPR_TIM2_REMAP_N, 8                    @ TIM2 remapping
.EQU  AFIO_MAPR_TIM2_NO_REMAP, 0                   @ No remap (CH1/ETR/PA0, CH2/PA1, CH3/PA2, CH4/PA3)
.EQU  AFIO_MAPR_TIM2_PART1_REMAP, 1 << 8           @ Partial remap (CH1/ETR/PA15, CH2/PB3, CH3/PA2, CH4/PA3)
.EQU  AFIO_MAPR_TIM2_PART2_REMAP, 2 << 8           @ Partial remap (CH1/ETR/PA0, CH2/PA1, CH3/PB10, CH4/PB11)
.EQU  AFIO_MAPR_TIM2_FULL_REMAP, 3 << 8            @ Full remap (CH1/ETR/PA15, CH2/PB3, CH3/PB10, CH4/PB11)
.EQU  AFIO_MAPR_TIM1_REMAP_N, 6                    @ TIM1 remapping
.EQU  AFIO_MAPR_TIM1_NO_REMAP, 0                   @ No remap (ETR/PA12, CH1/PA8, CH2/PA9, CH3/PA10, CH4/PA11, BKIN/PB12, CH1N/PB13, CH2N/PB14, CH3N/PB15)
.EQU  AFIO_MAPR_TIM1_PART_REMAP, 1 << 6            @ Partial remap (ETR/PA12, CH1/PA8, CH2/PA9, CH3/PA10, CH4/PA11, BKIN/PA6, CH1N/PA7, CH2N/PB0, CH3N/PB1)
.EQU  AFIO_MAPR_TIM1_FULL_REMAP, 3 << 6            @ Full remap (ETR/PE7, CH1/PE9, CH2/PE11, CH3/PE13, CH4/PE14, BKIN/PE15, CH1N/PE8, CH2N/PE10, CH3N/PE12)
.EQU  AFIO_MAPR_USART3_REMAP_N, 4                  @ USART3 remapping
.EQU  AFIO_MAPR_USART3_NO_REMAP, 0                 @ No remap (TX/PB10, RX/PB11, CK/PB12, CTS/PB13, RTS/PB14)
.EQU  AFIO_MAPR_USART3_PART_REMAP, 1 << 4          @ Partial remap (TX/PC10, RX/PC11, CK/PC12, CTS/PB13, RTS/PB14)
.EQU  AFIO_MAPR_USART3_FULL_REMAP, 3 << 4          @ Full remap (TX/PD8, RX/PD9, CK/PD10, CTS/PD11, RTS/PD12)
.EQU  AFIO_MAPR_USART2_REMAP_N, 3                  @ USART2 remapping
.EQU  AFIO_MAPR_USART2_NO_REMAP, 0                 @ No remap (CTS/PA0, RTS/PA1, TX/PA2, RX/PA3, CK/PA4)
.EQU  AFIO_MAPR_USART2_REMAP, 1 << 3               @ Remap (CTS/PD3, RTS/PD4, TX/PD5, RX/PD6, CK/PD7)
.EQU  AFIO_MAPR_USART1_REMAP_N, 2                  @ USART1 remapping
.EQU  AFIO_MAPR_USART1_NO_REMAP, 0                 @ No remap (TX/PA9, RX/PA10)
.EQU  AFIO_MAPR_USART1_REMAP, 1 << 2               @ Remap (TX/PB6, RX/PB7)
.EQU  AFIO_MAPR_I2C1_REMAP_N, 1                    @ I2C1 remapping
.EQU  AFIO_MAPR_I2C1_NO_REMAP, 0                   @ No remap (SCL/PB6, SDA/PB7)
.EQU  AFIO_MAPR_I2C1_REMAP, 1 << 1                 @ Remap (SCL/PB8, SDA/PB9)
.EQU  AFIO_MAPR_SPI1_REMAP_N, 0                    @ SPI1 remapping
.EQU  AFIO_MAPR_SPI1_NO_REMAP, 0                   @ No remap (NSS/PA4, SCK/PA5, MISO/PA6, MOSI/PA7)
.EQU  AFIO_MAPR_SPI1_REMAP, 1                      @ Remap (NSS/PA15, SCK/PB3, MISO/PB4, MOSI/PB5)

@.ITEM     AFIO_EXTICR1
.EQU  AFIO_EXTICR1_EXTI0_N, 0                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI1_N, 4                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI2_N, 8                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI3_N, 12                     @ Pin 0 EXTI Port

@.ITEM     AFIO_EXTICR2
.EQU  AFIO_EXTICR1_EXTI4_N, 0                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI5_N, 4                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI6_N, 8                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI7_N, 12                     @ Pin 0 EXTI Port

@.ITEM     AFIO_EXTICR3
.EQU  AFIO_EXTICR1_EXTI8_N, 0                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI9_N, 4                      @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI10_N, 8                     @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI11_N, 12                    @ Pin 0 EXTI Port

@.ITEM     AFIO_EXTICR4
.EQU  AFIO_EXTICR1_EXTI12_N, 0                     @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI13_N, 4                     @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI14_N, 8                     @ Pin 0 EXTI Port
.EQU  AFIO_EXTICR1_EXTI15_N, 12                    @ Pin 0 EXTI Port

@.ITEM     AFIO_EXTICR1 AFIO_EXTICR2 AFIO_EXTICR3 AFIO_EXTICR4
.EQU  AFIO_EXTI_PA       , 0                       @ GPIO A
.EQU  AFIO_EXTI_PB       , 1                       @ GPIO B
.EQU  AFIO_EXTI_PC       , 2                       @ GPIO C
.EQU  AFIO_EXTI_PD       , 3                       @ GPIO D
.EQU  AFIO_EXTI_PE       , 4                       @ GPIO E
.EQU  AFIO_EXTI_PF       , 5                       @ GPIO F
.EQU  AFIO_EXTI_PG       , 6                       @ GPIO G

@.ITEM     AFIO_MAPR2
.EQU  AFIO_MAPR2_MISC_REMAP_N, 13                  @ Bit 13 MISC_REMAP: Miscellaneous features remapping.
.EQU  AFIO_MAPR2_TIM12_REMAP_N, 12                 @ Bit 12 TIM12_REMAP: TIM12 remapping
.EQU  AFIO_MAPR2_TIM12_NO_REMAP, 0                 @ No remap (CH1/PC4, CH2/PC5)
.EQU  AFIO_MAPR2_TIM12_REMAP, 1 << 12              @ Remap (CH1/PB12, CH2/PB13)
.EQU  AFIO_MAPR2_TIM76_DAC_DMA_REMAP_N, 12         @ Bit 11 TIM76_DAC_DMA_REMAP: TIM67_DAC DMA remapping
.EQU  AFIO_MAPR2_TIM76_DAC_DMA_NO_REMAP, 0         @  No remap (TIM6_DAC1 DMA request/DMA2 Channel3, TIM7_DAC2 DMA request/DMA2 Channel4)
.EQU  AFIO_MAPR2_TIM76_DAC_DMA_REMAP, 1 << 12      @ Remap (TIM6_DAC1 DMA request/DMA1 Channel3, TIM7_DAC2 DMA request/DMA1 Channel4)
.EQU  AFIO_MAPR2_FSMC_NADV, 1 << 10                @ Bit 10 FSMC_NADV: NADV connect/disconnect
.EQU  AFIO_MAPR2_TIM14_REMAP_N, 9                  @ Bit 9 TIM14_REMAP: TIM14 remapping
.EQU  AFIO_MAPR2_TIM14_NO_REMAP, 0                 @ No remap (PC9)
.EQU  AFIO_MAPR2_TIM14_REMAP, 1 << 9               @ Remap (PB1)
.EQU  AFIO_MAPR2_TIM13_REMAP_N, 8                  @ Bit 8 TIM13_REMAP: TIM13 remapping
.EQU  AFIO_MAPR2_TIM13_NO_REMAP, 0                 @ No remap (PC8)
.EQU  AFIO_MAPR2_TIM13_REMAP, 1 << 8               @ Remap (PB0)
.EQU  AFIO_MAPR2_TIM1_DMA_REMAP_N, 4               @ Bit 4 TIM1_DMA_REMAP: TIM1 DMA remapping
.EQU  AFIO_MAPR2_TIM1_DMA_NO_REMAP, 0              @ No remap (TIM1_CH1 DMA request/DMA1 Channel2, TIM1_CH2 DMA request/DMA1 Channel3)
.EQU  AFIO_MAPR2_TIM1_DMA_REMAP, 1 << 4            @ Remap (TIM1_CH1 DMA request/DMA1 Channel6, TIM1_CH2 DMA request/DMA1 Channel6)
.EQU  AFIO_MAPR2_CEC_REMAP_N, 3                    @ Bit 3 CEC_REMAP: CEC remapping
.EQU  AFIO_MAPR2_CEC_NO_REMAP, 0                   @ No remap (CEC/PB8)
.EQU  AFIO_MAPR2_CEC_REMAP, 1 << 3                 @ Remap (CEC/PB10)
.EQU  AFIO_MAPR2_TIM17_REMAP_N, 2                  @ Bit 2 TIM17_REMAP: TIM17 remapping
.EQU  AFIO_MAPR2_TIM17_NO_REMAP, 0                 @ No remap (CH1/PB9)
.EQU  AFIO_MAPR2_TIM17_REMAP, 1 << 2               @ Remap (CH1/PA7)
.EQU  AFIO_MAPR2_TIM16_REMAP_N, 1                  @ Bit 1 TIM16_REMAP: TIM16 remapping
.EQU  AFIO_MAPR2_TIM16_NO_REMAP, 0                 @ No remap (CH1/PB8)
.EQU  AFIO_MAPR2_TIM16_REMAP, 1 << 1               @ Remap (CH1/PA6)
.EQU  AFIO_MAPR2_TIM15_REMAP_N, 0                  @ Bit 1 TIM16_REMAP: TIM16 remapping
.EQU  AFIO_MAPR2_TIM15_NO_REMAP, 0                 @ No remap (CH1/PA2, CH2/PA3)
.EQU  AFIO_MAPR2_TIM15_REMAP, 1                    @ Remap (CH1/PB14, CH2/PB15)

@.ITEM    GPIO clock cases
     .EQU CLOCK_AFIO,  0x01
     .EQU CLOCK_GPIOA, 0x04
     .EQU CLOCK_GPIOB, 0x08
     .EQU CLOCK_GPIOC, 0x10
     .EQU CLOCK_GPIOD, 0x20
     .EQU CLOCK_GPIOE, 0x40
@.END

@.ITEM    Port settings
     .EQU INPUT_ANALOG       ,0x00
     .EQU INPUT_FLOATING     ,0x04
     .EQU INPUT_PUPD         ,0x08
     @2MHz
     .EQU OUTPUT_2_PP        ,0x02
     .EQU OUTPUT_2_OD        ,0x06
     .EQU OUTPUT_2_AFPP      ,0x0A
     .EQU OUTPUT_2_AFPP      ,0x0E
     @10MHz
     .EQU OUTPUT_10_PP        ,0x01
     .EQU OUTPUT_10_OD        ,0x05
     .EQU OUTPUT_10_AFPP      ,0x09
     .EQU OUTPUT_10_AFOD      ,0x0D
     @50MHz
     .EQU OUTPUT_50_PP        ,0x03
     .EQU OUTPUT_50_OD        ,0x07
     .EQU OUTPUT_50_AFPP      ,0x0B
     .EQU OUTPUT_50_AFOD      ,0x0F
     .EQU PIN_SET_PULLUP      ,0x10000
@.END


