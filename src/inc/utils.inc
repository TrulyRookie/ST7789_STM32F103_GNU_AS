@.CHARSET CP1251
.include "/src/inc/base.inc"
.include "/src/inc/gpio.inc"

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


.macro BBREG destReg, regPeriphBaseAddr, periphRegShift, regBit
    LDR \destReg, =PERIPH_BASE+PERIPH_BB_BASE
    LSL \regPeriphBaseAddr, \regPeriphBaseAddr, #5    @PERIPH_REG_BASE*32
    ADD \destReg, \destReg, \regPeriphBaseAddr
    LDR \regPeriphBaseAddr, =\periphRegShift
    LSL \regPeriphBaseAddr, \regPeriphBaseAddr, #5
    ADD \destReg, \destReg, \regPeriphBaseAddr        @ PERIPH_BASE+PERIPH_BB_BASE + (regPeriphBaseAddr+periphRegShift)*32
    LSL \regBit, \regBit, #2
    ADD \destReg, \destReg, \regBit      @ PERIPH_BASE+PERIPH_BB_BASE + (regPeriphBaseAddr+periphRegShift)*32 + bit*4
.endm

.macro BBR  destReg, periphRegBaseAddr, periphRegShift, regBit
    LDR \destReg, =PERIPH_BASE+PERIPH_BB_BASE+(\periphRegBaseAddr+\periphRegShift)*32
    LSL \regBit, \regBit, #2
    ADD \destReg, \regBit      @ PERIPH_BASE+PERIPH_BB_BASE + (regPeriphBaseAddr+periphRegShift)*32 + bit*4
.endm

.macro BBRG destReg, regPeriphBaseAddr, regPeriphShift, regBit
    LDR \destReg, =PERIPH_BASE+PERIPH_BB_BASE
    ADD \regPeriphBaseAddr, \regPeriphShift
    LSL \regPeriphBaseAddr, \regPeriphBaseAddr, #5
    ADD \destReg, \regPeriphBaseAddr        @ PERIPH_BASE+PERIPH_BB_BASE + (regPeriphBaseAddr+periphRegShift)*32
    LSL \regBit, \regBit, #2
    ADD \destReg, \destReg, \regBit      @ PERIPH_BASE+PERIPH_BB_BASE + (regPeriphBaseAddr+periphRegShift)*32 + bit*4
.endm


