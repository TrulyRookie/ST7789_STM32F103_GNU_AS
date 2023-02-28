@.CHARSET CP1251

@ +-------------------------------------------------------------------+
@ |                        Определения FLASH                          |
@ | STM32F101xxx STM32F102xxx STM32F103xxx STM32F105xxx STM32F107xxx  |
@ +-------------------------------------------------------------------+

.include "/src/inc/base.inc"

@.item AHBPERIPH_BASE
.EQU  FLASH         , ( AHBPERIPH_BASE + 0x2000 )
@.end

@.item FLASH
.EQU  FLASH_ACR     , 0X00    @ Flash access control register
@.END

@.ITEM FLASH_ACR
.EQU  FLASH_ACR_PRFTBS_N, 5    @ Bit 5 PRFTBS: Prefetch buffer status
                               @ This bit provides the status of the prefetch buffer.
                               @ 0: Prefetch buffer is disabled
.EQU  FLASH_ACR_PRFTBS, 1 << 5 @ 1: Prefetch buffer is enabled
.EQU  FLASH_ACR_PRFTBE_N, 4    @ Bit 4 PRFTBE: Prefetch buffer enable
                               @ 0: Prefetch is disabled
.EQU  FLASH_ACR_PRFTBE, 1<<4   @ 1: Prefetch is enabled
.EQU  FLASH_ACR_HLFCYA_N, 3    @ Bit 3 HLFCYA: Flash half cycle access enable
                               @ 0: Half cycle is disabled
.EQU  FLASH_ACR_HLFCYA, 1<<3   @ 1: Half cycle is enabled
.EQU  FLASH_ACR_LATENCY_N, 0    @ Bits 2:0 LATENCY: Latency
.equ  FLASH_ACR_LATENCY_L, 3    @ These bits represent the ratio of the SYSCLK (system clock) period to the Flash access time.
.EQU  FLASH_ACR_LATENCY_0, 0    @ 000 Zero wait state, if 0 < SYSCLK 24 MHz
.EQU  FLASH_ACR_LATENCY_1, 1    @ 001 One wait state, if 24 MHz < SYSCLK  48 MHz
.EQU  FLASH_ACR_LATENCY_2, 2    @ 010 Two wait states, if 48 MHz < SYSCLK  72 MHz
@.END


