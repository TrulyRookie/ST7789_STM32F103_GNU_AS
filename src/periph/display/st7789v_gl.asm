@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор

.include "/src/periph/display/st7789v.inc"

.section .asmcode
DATA_FOR_PVGAMCTRL: .byte 0xd0, 0x04, 0x0d, 0x11, 0x13, 0x2b, 0x3f, 0x54, 0x4c, 0x18, 0x0d, 0x0b, 0x1F, 0x23
DATA_FOR_NVGAMCTRL: .byte 0xd0, 0x04, 0x0c, 0x11, 0x13, 0x2c, 0x3f, 0x44, 0x51, 0x2F, 0x1f, 0x1f, 0x20, 0x23
@.DESC     name=LCD_SetViewport type=proc
@ ***************************************************************************
@ *                  Задание прямоугольной области экрана                   *
@ ***************************************************************************
@ | Задание области экрана для операций                                     |
@ | Параметры:                                                              |
@ |  R0 - координаты X: 31:16 - SX, 15:0 - EX                               |
@ |  R1 - координаты Y: 31:16 - SY, 15:0 - EY                               |
@ +-------------------------------------------------------------------------+
@.ENDDESC
.global LCD_SetViewport
LCD_SetViewport:
     PUSH {r0,r1,LR}
          MOV r2,r0
          UBFX r0, r2, #16, #16   @XS
          UBFX r1, r2, #0, #16    @XE
          BL ST_CASET             @(XS,XE)
     POP {r0,r1,LR}
     PUSH {r0,r1,LR}
          MOV r2,r1
          UBFX r0, r2, #16, #16   @YS
          UBFX r1, r2, #0, #16    @YE
          BL ST_RASET             @(YS,YE)
     POP {r0,r1,LR}
     BX LR

@.DESC     name=LCD_Clear type=proc
@ ***************************************************************************
@ *                  Очиста экрана цветом                                   *
@ ***************************************************************************
@ | Задание области экрана для операций                                     |
@ | Параметры:                                                              |
@ |  R0 - цвет(5+6+5 бит r+g+b) 16bit                                      |
@ +-------------------------------------------------------------------------+
@.ENDDESC
.global LCD_Clear
LCD_Clear:
     PUSH {r0,r1,LR}
        MOVW r0, CANVAS_WIDTH-1    @XE
        MOVT r0, 0                 @XS
        MOVW r1, CANVAS_HEIGHT-1   @YE
        MOVT r1, 0                 @YS
        BL LCD_SetViewport
     POP {r0,r1,LR}
     PUSH {r0-r3,r5,LR}
        MOV r2, r0
        LDR r4, =CANVAS_WIDTH
        MOV r1, #1
        MOV r3, #5
        MUL r0, r4, r3           @ r0 = CANVAS_WIDTH * 5 (array size)
        BL GetFilledArray
        MOV r0, r5               @ r0 = &array
        LDR r2, =CANVAS_HEIGHT   @ r2 = CANVAS_HEIGHT
        SDIV r1, r2, r3          @ r1 = CANVAS_HEIGHT/5
        @LSL r1, r12, #1
        BL ST_RAMWR_CIRC
        BL ReleaseArray
     POP {r0-r3,r5,LR}
     BX LR

@.DESC     name=LCD_MakeColor type=proc
@ ***************************************************************************
@ *                  Инициализация ЖК панели                                *
@ ***************************************************************************
@ * Вход: R0 - R (0..31), R1 - G (0..63), R2 - B (0..31)                    *
@ * Результат: R5 - 16bit color                                             *
@ ***************************************************************************
@.ENDDESC
.global LCD_MakeColor
LCD_MakeColor:
     PUSH {r0-r2,LR}
          EOR r5,r5
          BFI r5, r0, #11, #5
          BFI r5, r1, #5, #6
          BFI r5, r2, #0, #5
          @REV16 r0, r5
          MOV r5, r0
     POP {r0-r2,LR}
     BX LR

@.DESC     name=LCD_Init type=proc
@ ***************************************************************************
@ *                  Инициализация ЖК панели                                *
@ ***************************************************************************
@.ENDDESC
.global LCD_Init
LCD_Init:
     PUSH {r0-r5,LR}
          BL HardResetDisplay
          BL ST_SWRESET
          MOV r0, #130
          BL SYSTICK_DELAY

          MOV r0, #5
          LDR r1, =#0
          BL GetArray
          LDR r0, =0xc0
          LDR r1, =0x33
          EOR r2, r2
          STRB r0, [r5,0]
          STRB r0, [r5,1]
          STRB r2, [r5,2]
          STRB r1, [r5,3]
          STRB r1, [r5,4]
          MOV r0, r5
          BL ST_PORCTRL
          BL ReleaseArray
          BL ST_IDMOFF
          MOV r0, RGB_65K_16BIT
          BL ST_COLMOD
          LDR r0, =#100
          BL SYSTICK_DELAY
LCD_init_orient:
          MOV r0, DISP_ORIENTATION
          BL ST_MADCTL
          LDR r0, =#10
          BL SYSTICK_DELAY

           MOV r0, 0x35 @ +13.26V, -10.43V
          BL ST_GCTRL
          MOV r0, 0x19  @0.725V
          BL ST_VCOMS

          MOV r0, 0x2C
          BL ST_LCMCTRL

          LDR r0, =#1
          BL ST_VDVVRHEN

          MOV r0, #0x12 @  -4.45V
          BL ST_VRHS

          MOV r0, #20 @def 0V
          BL ST_VDVS

          MOV r0, #0x0F   @60Hz  dot inversion
          BL ST_FRCTRL2

          MOV r0, #0xA1
          BL ST_PWCTRL1

          LDR r2, =DATA_FOR_PVGAMCTRL
          MOV r0, #14
          LDR r1, =#0
          BL GetArray
          EOR r3, r3
data_copy_0:
          LDRB r4, [r2,r3]
          STRB r4, [r5,r3]
          ADD r3, #1
          CMP r3, r0
          BNE data_copy_0
          MOV r0, r5
          BL ST_PVGAMCTRL   @gamma control magic
          BL ReleaseArray

          LDR r2, =DATA_FOR_NVGAMCTRL
          MOV r0, #14
          LDR r1, =#0
          BL GetArray
          EOR r3, r3
data_copy_1:
          LDRB r4, [r2,r3]
          STRB r4, [r5,r3]
          ADD r3, #1
          CMP r3, r0
          BNE data_copy_1
          MOV r0, r5
          BL ST_NVGAMCTRL   @gamma control magic 2
          BL ReleaseArray

          BL ST_INVON
          LDR r0, = #10
          BL SYSTICK_DELAY
          BL ST_NORON
          BL SYSTICK_DELAY
          BL ST_SLPOUT
          LDR r0, =#100
          BL SYSTICK_DELAY
          BL ST_DISPON
          BL SYSTICK_DELAY
          MOV r0, #31
          MOV r1, #63
          MOV r2, #0
          BL LCD_MakeColor
          MOV r0,r5
          BL LCD_Clear
     POP {r0-r5,LR}
     BX LR


