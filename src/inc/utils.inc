@.CHARSET CP1251
.ifndef UTILS_INC
     .equ UTILS_INC, 1

.include "/src/inc/base.inc"
.include "/src/inc/gpio.inc"

.equ PROFILING_IS_ON, 1

.if (PROFILING_IS_ON == 1)
     .equ      SCB_DEMCR,  0xE000EDFC
     .equ      DWT_CYCCNT, 0xE0001004
     .equ      DWT_CONTROL, 0xE0001000
     .equ      CoreDebug_DEMCR_TRCENA, 1<<24
     .equ      DWT_CTRL_CYCCNTENA, 1

DWT_START:
PUSH {r0-r3, lr}
          @ DWT_CYCCNT = 0; // обнуляем значение
          @ DWT_CONTROL|= DWT_CTRL_CYCCNTENA_Msk; // включаем счётчик
          LDR r0, =DWT_CYCCNT
          STR r11, [r0]
          LDR r1, =DWT_CONTROL
          LDR r2, [r1]
          LDR r3, =DWT_CTRL_CYCCNTENA
          ORR r2, r3
          STR r2, [r1]
POP {r0-r3, lr}
BX LR

DWT_STOP:
PUSH {r0-r3, R10, lr}
          @ DWT_CYCCNT = 0; // обнуляем значение
          @ DWT_CONTROL|= DWT_CTRL_CYCCNTENA_Msk; // включаем счётчик
          LDR r0, =DWT_CYCCNT
          LDR r10, [r0]
          LDR r1, =DWT_CONTROL
          LDR r2, [r1]
          LDR r3, =DWT_CTRL_CYCCNTENA
          EOR r2, r3
          STR r2, [r1]
          SUB r10, #29
POP {r0-r3, R10, lr}
BX LR

.macro START_DWT_CHECK
     .if (PROFILING_IS_ON == 1)
          BL DWT_START
     .endif
.endm

.macro STOP_DWT_CHECK
     .if (PROFILING_IS_ON == 1)
          BL DWT_STOP
     .endif
.endm

.endif

@ 32bit immediate load to register
.macro MOVD reg, word_val
     MOVW \reg, #:lower16:\word_val
     MOVT \reg, #:upper16:\word_val
.endm
@ peripheria bit-banding
.macro BBP reg, perif_reg_base, perif_reg, bit
     LDR \reg, =((PERIPH_BASE+PERIPH_BB_BASE)+((\perif_reg_base+\perif_reg)*32+\bit*4))
.endm
@ memory bit-banding
.macro BBM reg, memory_address, bit
     LDR \reg, =((SRAM_BASE+SRAM_BB_BASE)+(\memory_address*32+\bit*4))
.endm
@GPIO bit set/reset r0, r1 registers
.macro GPIO_SET gpio_base, pin
     BBP r3, \gpio_base, GPIO_BSRR, \pin
     MOV r2, #1
     STR r2, [r3]
.endm

.macro GPIO_CLEAR gpio_base, pin
     BBP r3, \gpio_base, GPIO_BSRR, (\pin+16)
     MOV r2, #1
     STR r2, [r3]
.endm

.macro LVR reg, label
     LDR \reg, =\label
     LDR \reg, [\reg]
.endm

.endif


.macro mod rg1, rg2, rg3
     SDIV \rg1, \rg2, \rg3  @ rg1 = rg2/rg3
     MUL \rg1, \rg3, \rg1   @ rg1 *= rg3
     SUB \rg1, \rg2, \rg1   @ rg1 = rg2 - rg1
.endm

.macro imod rg1, rg2, imm12
     SDIV \rg1, \rg2, \imm12  @ rg1 = rg2/imm12
     MUL \rg1, \rg1, \imm12   @ rg1 *= imm12
     SUB \rg1, \rg2, \rg1   @ rg1 = rg2 - rg1
.endm


