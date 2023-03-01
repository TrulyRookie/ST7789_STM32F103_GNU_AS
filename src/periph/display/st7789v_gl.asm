@.CHARSET =CP1251
@GNU AS

.SYNTAX        unified             @ синтаксис исходного кода
.THUMB                             @ тип используемых инструкций Thumb
.CPU           cortex-m3           @ процессор

.INCLUDE       "/src/inc/st7789v.inc"

.SECTION       .asmcode
DATA_FOR_PVGAMCTRL: .BYTE           0xd0, 0x04, 0x0d, 0x11, 0x13, 0x2b, 0x3f, 0x54, 0x4c, 0x18, 0x0d, 0x0b, 0x1F, 0x23
DATA_FOR_NVGAMCTRL: .BYTE           0xd0, 0x04, 0x0c, 0x11, 0x13, 0x2c, 0x3f, 0x44, 0x51, 0x2F, 0x1f, 0x1f, 0x20, 0x23
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
.GLOBAL        LCD_SetViewport
LCD_SetViewport:
                    PUSH            { R0, R1, LR }
                    MOV             R2, R0
                    UBFX            R0, R2, #16, #16    @XS
                    UBFX            R1, R2, #0, #16    @XE
                    BL              ST_CASET    @(XS,XE)
                    POP             { R0, R1, LR }
                    PUSH            { R0, R1, LR }
                    MOV             R2, R1
                    UBFX            R0, R2, #16, #16    @YS
                    UBFX            R1, R2, #0, #16    @YE
                    BL              ST_RASET    @(YS,YE)
                    POP             { R0, R1, LR }
                    BX              LR

@.DESC     name=LCD_Clear type=proc
@ ***************************************************************************
@ *                  Очиста экрана цветом                                   *
@ ***************************************************************************
@ | Задание области экрана для операций                                     |
@ | Параметры:                                                              |
@ |  R0 - цвет(5+6+5 бит r+g+b) 16bit                                      |
@ +-------------------------------------------------------------------------+
@.ENDDESC
.GLOBAL        LCD_Clear
LCD_Clear:
                    PUSH            { R0, R1, LR }
                    MOVW            R0, CANVAS_WIDTH - 1    @XE
                    MOVT            R0, 0    @XS
                    MOVW            R1, CANVAS_HEIGHT - 1    @YE
                    MOVT            R1, 0    @YS
                    BL              LCD_SetViewport
                    POP             { R0, R1, LR }
                    PUSH            { R0 - R5, LR }
                    MOV             R2, R0
                    LDR             R4, = CANVAS_WIDTH
                    MOV             R1, #1
                    MOV             R3, #5
                    MUL             R0, R4, R3    @ r0 = CANVAS_WIDTH * 5 (array size)
                    BL              GetFilledArray
                    MOV             R0, R5    @ r0 = &array
                    LDR             R2, = CANVAS_HEIGHT    @ r2 = CANVAS_HEIGHT
                    SDIV            R1, R2, R3    @ r1 = CANVAS_HEIGHT/5
                    BL              ST_RAMWR_CIRC
                    BL              ReleaseArray
                    POP             { R0 - R5, LR }
                    BX              LR

@.DESC     name=LCD_MakeColor type=proc
@ ***************************************************************************
@ *                  Make 16bit color from RGB                              *
@ ***************************************************************************
@ * Вход: R0 - R (0..31), R1 - G (0..63), R2 - B (0..31)                    *
@ * Результат: R5 - 16bit color                                             *
@ ***************************************************************************
@.ENDDESC
.GLOBAL        LCD_MakeColor
LCD_MakeColor:
                    PUSH            { R0 - R2, LR }
                    EOR             R5, R5
                    BFI             R5, R0, #11, #5
                    BFI             R5, R1, #5, #6
                    BFI             R5, R2, #0, #5
                    POP             { R0 - R2, LR }
                    BX              LR

@.DESC     name=LCD_Convert24bitColor type=proc
@ ***************************************************************************
@ *                  Make 16bit color from 24bit                            *
@ ***************************************************************************
@ * Вход: R0 - 24bit color (RGB)                                            *
@ * Результат: R5 - 16bit color                                             *
@ ***************************************************************************
@.ENDDESC
.GLOBAL        LCD_Convert24bitColor
LCD_Convert24bitColor:
                    PUSH            { R0 - R2, LR }
                    EOR             R5, R5
          @ convert R: R16 = R24 * 31/255
                    MOV             R1, #31
                    MOV             R2, #0xFF
                    UBFX            R3, R0, #16, #8
                    MUL             R1, R3
                    UDIV            R1, R2
                    BFI             R5, R1, #11, #5
          @ convert R: G16 = G24 * 63/255
                    MOV             R1, #63
                    MOV             R2, #0xFF
                    UBFX            R3, R0, #8, #8
                    MUL             R1, R3
                    UDIV            R1, R2
                    BFI             R5, R1, #5, #6
          @ convert R: B16 = B24 * 31/255
                    MOV             R1, #31
                    MOV             R2, #0xFF
                    UBFX            R3, R0, #0, #8
                    MUL             R1, R3
                    UDIV            R1, R2
                    BFI             R5, R1, #0, #5
                    POP             { R0 - R2, LR }
                    BX              LR

@.DESC     name=LCD_Init type=proc
@ ***************************************************************************
@ *                  Инициализация ЖК панели                                *
@ ***************************************************************************
@.ENDDESC
.GLOBAL        LCD_Init
LCD_Init:
                    PUSH            { R0 - R5, LR }
                    BL              HardResetDisplay
                    BL              ST_SWRESET
                    MOV             R0, #130
                    BL              SYSTICK_DELAY
                    MOV             R0, #5
                    MOV             R1, #0
                    BL              GetArray
                    LDR             R0, = 0xc0
                    LDR             R1, = 0x33
                    EOR             R2, R2
                    STRB            R0, [ R5, 0 ]
                    STRB            R0, [ R5, 1 ]
                    STRB            R2, [ R5, 2 ]
                    STRB            R1, [ R5, 3 ]
                    STRB            R1, [ R5, 4 ]
                    MOV             R0, R5
                    BL              ST_PORCTRL
                    BL              ReleaseArray
                    BL              ST_IDMOFF
                    MOV             R0, RGB_65K_16BIT
                    BL              ST_COLMOD
                    MOV             R0, #100
                    BL              SYSTICK_DELAY
                    MOV             R0, DISP_ORIENTATION
                    BL              ST_MADCTL
                    MOV             R0, #10
                    BL              SYSTICK_DELAY
                    BL              ST_INVON
                    MOV             R0, #10
                    BL              SYSTICK_DELAY
                    BL              ST_NORON
                    BL              SYSTICK_DELAY
                    BL              ST_SLPOUT
                    MOV             R0, #100
                    BL              SYSTICK_DELAY
                    BL              ST_DISPON
                    BL              SYSTICK_DELAY
                    LDR             R0, = #0xFFF3BC
                    BL              LCD_Convert24bitColor
                    MOV             R0, R5
                    BL              LCD_Clear
                    POP             { R0 - R5, LR }
                    BX              LR


