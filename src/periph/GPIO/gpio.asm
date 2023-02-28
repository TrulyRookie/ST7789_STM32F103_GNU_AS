@.CHARSET CP1251

@ GNU AS
.syntax unified
.cpu cortex-m3
.thumb
.include "/src/inc/rcc.inc"
.include "/src/inc/utils.inc"

@.DESC name=GPIO_ClockON  type=proc
@ ***********************************************
@ *Enables clocking of general purpose I/O ports*
@ ***********************************************
@ * INPUT:                                      *
@ *       R0 - GPIO clock settings              *
@ * OUTPUT:                                     *
@ *       NONE                                  *
@ ***********************************************
@.ENDDESC
.global GPIO_ClockON
GPIO_ClockON:
     push {r1,r2,LR}                @ GPIO_ClockON(r0)
     LDR R1, =(RCC+RCC_APB2ENR)     @ r1 = &APB2ENR
     LDR R2, [R1]                   @ r2 = *APB2ENR
     BFI R2, R0, #0, #7             @ switch bit field in r2
     STR R2, [R1]                   @ *APB2ENR = r2
     POP {r1,r2,LR}                 @ return
     BX LR

@.DESC name=GPIO_PinTuning type=proc
@ ***********************************************
@ *            Tune GPIO PIN                    *
@ ***********************************************
@ * INPUT:                                      *
@ *       R0 - GPIO address                     *
@ *       R1 - pin number                       *
@ *       R2 - pin settigs                      *
@ * OUTPUT:                                     *
@ *       NONE                                  *
@ ***********************************************
@.ENDDESC
.global GPIO_PinTuning
GPIO_PinTuning:
     PUSH {r0-r4,lr}
          CMP r1, #7                 @ if (pinNumber > 7)
          ITT HI                     @ {
          ADDHI r0, r3               @   GPIO += 4
          SUBHI r1, #8               @   pinNumber -= 8 };
          LSL r1, r1, #2             @ pinNumber*=4
          LDR r3, [r0]               @ r3 = *GPIO
          UBFX r4, r2, #0, #4        @ r4 = r2 & 0x0F
          LSL r4, r4, r1             @ r4 = CNF_MODE << pinNumber
          MOV r5, 0x0f               @ 0b00000000000000000000000000001111
          LSL r5, r5, r1             @ 0b00000000000000000000111100000000
          MVN r5, r5                 @ 0b11111111111111111111000011111111
          AND r3, r3, r5             @ 0b11111111111111111111000011111111
          ORR r3, r3, r4
          STR r3, [r0]               @ *GPIO = r3
          MOV r0, SP
          LDR r1, [r0, 4]           @get r1 from stack
          LDR r0, [r0]               @get r0 from stack
          LSR r4, r2, #16            @ r4 = r2>>16
          LDR r2, =PERIPH_BASE       @
          SUB r0, r0, r2             @ GPIO = GPIO_BASE
          LDR r2, =(PERIPH_BASE+PERIPH_BB_BASE)
          LDR r3, =GPIO_BSRR
          ADD R0, r3                 @  GPIO_BASE+GPIO_BSRR
          LSL r0, r0, #5             @ (GPIO_BASE+GPIO_BSRR)*32
          LSL r1, r1, #2             @ pinNumber*4
          ADD r0, r2                 @ (PERIPH_BASE+PERIPH_BB_BASE)+(GPIO_BASE+GPIO_BSRR)*32
          ADD r0, r1                 @ (PERIPH_BASE+PERIPH_BB_BASE)+(GPIO_BASE+GPIO_BSRR)*32+pinNumber*4
          MOV r5, r0                 @ BB pin set bit to r5
          MOV r6, r0
          LSL r1, r12, #6            @ 16*4
          ADD R6, R1                 @ (PERIPH_BASE+PERIPH_BB_BASE)+(GPIO_BASE+GPIO_BSRR)*32+(pinNumber+16)*4
          CBNZ r4, PinTuning_Set     @ if (r4==1) set();
          STR r12, [r6]              @ LOW
          B PinTuning_Return
PinTuning_Set:
          STR r12, [r5]              @ HI
PinTuning_Return:
     pop {r0-r4, LR}
     BX LR


