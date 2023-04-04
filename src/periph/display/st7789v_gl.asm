@.CHARSET =CP1251
@GNU AS

.SYNTAX unified   @ синтаксис исходного кода
.THUMB   @ тип используемых инструкций Thumb
.CPU cortex-m3   @ процессор

.INCLUDE   "/src/inc/st7789v.inc"
.INCLUDE   "/src/inc/utils.inc"
.SECTION .bss
.global GL_PAR
.ALIGN ( 2 )
GL_PAR:
     GL_BACKGROUND_COLOR:     .word 0
     GL_FOREGROUND_COLOR:     .word 0
     GL_FONT:                 .word 0
     GL_FONT_MODE:            .word 0

.SECTION .asmcode
.GLOBAL SetInk
SetInk:
     PUSH {r1, LR}
     LDR R1, =GL_PAR
     STR R0, [R1, GL_FOREGROUND_COLOR - GL_PAR]
     POP {r1, LR}
     BX LR

.global SetPaper
SetPaper:
     PUSH {r1, LR}
     LDR R1, =GL_PAR
     STR R0, [R1, GL_BACKGROUND_COLOR - GL_PAR]
     POP {r1, LR}
     BX LR
.global SetFont
SetFont:
     PUSH {r1, LR}
     LDR R1, =GL_PAR
     STR R0, [R1, GL_FONT - GL_PAR]
     POP {r1, LR}
     BX LR

.global SetFontType
SetFontType:
     PUSH {r1, LR}
     LDR R1, =GL_PAR
     STR R0, [R1, GL_FONT_MODE-GL_PAR]
     POP {r1, LR}
     BX LR

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
.GLOBAL LCD_SetViewport
LCD_SetViewport:
     PUSH  { R0, R1, R2, LR }
     MOV R2, R1
     MOV R1, R0
     BL ST_CASET
     MOV R1, R2
     BL ST_RASET
     @RAMWR command send
     BL ST_RAMWR
     POP  { R0, R1, R2, LR }
     BX  LR

@.DESC     name=LCD_Clear type=proc
@ ***************************************************************************
@ *                  Очиста экрана цветом                                   *
@ ***************************************************************************
@ | Задание области экрана для операций                                     |
@ | Параметры:                                                              |
@ |  R0 - цвет(5+6+5 бит r+g+b) 16bit                                      |
@ +-------------------------------------------------------------------------+
@.ENDDESC

.GLOBAL LCD_Clear
LCD_Clear:
     PUSH  { R0 - R6, LR }

     MOVW  R0, CANVAS_WIDTH - 1         @XE
     MOVT  R0, 0                        @XS
     MOVW  R1, CANVAS_HEIGHT - 1        @YE
     MOVT  R1, 0                        @YS
     BL  LCD_SetViewport

     LDR R0, =GL_PAR
     LDR R2, [r0, GL_BACKGROUND_COLOR-GL_PAR]
     REV16  R2, R2
     LDR  R4, = CANVAS_WIDTH
     MOV  R1, #1
     MOV  R3, #5
     MUL  R0, R4, R3                    @ r0 = CANVAS_WIDTH * 5 (array size)
     BL  GetFilledArray
     MOV  R0, R5                        @ r0 = &array
     LDR  R2, = CANVAS_HEIGHT           @ r2 = CANVAS_HEIGHT
     SDIV  R6, R2, R3                   @ r1 = CANVAS_HEIGHT/5
     BL  SendParameters

     BL  ReleaseArray
     POP  { R0 - R6, LR }
     BX  LR

@.DESC     name=LCD_MakeColor type=proc
@ ***************************************************************************
@ *                  Make 16bit color from RGB                              *
@ ***************************************************************************
@ * Вход: R0 - R (0..31), R1 - G (0..63), R2 - B (0..31)                    *
@ * Результат: R5 - 16bit color                                             *
@ ***************************************************************************
@.ENDDESC
.GLOBAL LCD_MakeColor
LCD_MakeColor:
     PUSH  { R0 - R2, LR }
     EOR  R5, R5
     BFI  R5, R0, #11, #5
     BFI  R5, R1, #5, #6
     BFI  R5, R2, #0, #5
     POP  { R0 - R2, LR }
     BX  LR

@.DESC     name=LCD_Convert24bitColor type=proc
@ ***************************************************************************
@ *                  Make 16bit color from 24bit                            *
@ ***************************************************************************
@ * Вход: R0 - 24bit color (RGB)                                            *
@ * Результат: R5 - 16bit color                                             *
@ ***************************************************************************
@.ENDDESC
.GLOBAL LCD_Convert24bitColor
LCD_Convert24bitColor:
     PUSH  { R0 - R2, LR }
     EOR  R5, R5
          @ convert R: R16 = R24 * 31/255
     MOV  R1, #31
     MOV  R2, #0xFF
     UBFX  R3, R0, #16, #8
     MUL  R1, R3
     UDIV  R1, R2
     BFI  R5, R1, #11, #5
          @ convert R: G16 = G24 * 63/255
     MOV  R1, #63
     MOV  R2, #0xFF
     UBFX  R3, R0, #8, #8
     MUL  R1, R3
     UDIV  R1, R2
     BFI  R5, R1, #5, #6
          @ convert R: B16 = B24 * 31/255
     MOV  R1, #31
     MOV  R2, #0xFF
     UBFX  R3, R0, #0, #8
     MUL  R1, R3
     UDIV  R1, R2
     BFI  R5, R1, #0, #5
     POP  { R0 - R2, LR }
     BX  LR

@.DESC     name=LCD_Init type=proc
@ ***************************************************************************
@ *                  Инициализация ЖК панели                                *
@ ***************************************************************************
@.ENDDESC
.GLOBAL LCD_Init
LCD_Init:
     PUSH  { R0 - R5, LR }
     BL SelectSlave
     BL  HardResetDisplay
     BL ST_SWRESET
     MOV  R0, #130
     BL SYSTICK_DELAY
     BL ST_IDMOFF

     MOV  R1, RGB_65K_16BIT
     BL ST_COLMOD

     MOV  R0, #100
     BL  SYSTICK_DELAY

     MOV R1, DISP_ORIENTATION
     BL ST_MADCTL

     MOV  R0, #10
     BL  SYSTICK_DELAY
     BL  ST_INVON
     MOV  R0, #10
     BL  SYSTICK_DELAY
     BL ST_NORON
     BL  SYSTICK_DELAY
     BL ST_SLPOUT
     MOV  R0, #100
     BL  SYSTICK_DELAY
     BL  ST_DISPON
     BL  SYSTICK_DELAY
     LDR  R0, = #0xFFF3BC
     BL  LCD_Convert24bitColor
     LDR  R0, =GL_PAR
     STR R5, [R0, GL_BACKGROUND_COLOR-GL_PAR]
     BL  LCD_Clear
     LDR R0, =GL_FONT
     LDR R1, =font16x16_sys
     STR r1, [r0]
     MOV r1, 1
     STR r1, [r0,4]
     POP  { R0 - R5 , LR }
     BX  LR

@.DESC    name=LCD_DrawPixel type=proc
@         Draw pixel to the screen
@         IN: R0 - x, R1 - y, COLOR  is foreground color
@.ENDDESC
@ r0 - X, r1 - Y
.GLOBAL LCD_DrawPixel
LCD_DrawPixel:
     PUSH  { r0-r1, LR }
     @BL ResetRegisters
     BFI R0, R0, #16, #16
     BFI R1, R1, #16, #16
     BL  LCD_SetViewport
     LDR R0, =GL_PAR
     LDR R0, [R0, GL_FOREGROUND_COLOR-GL_PAR]
     BL  Send2BParameters
     POP  { r0-r1, LR }
     BX  LR

@.DESC  name=LCD_DrawLine type=proc
     @ Draw line (Bresenham's line algorithm)
     @ IN R0 - X0:Y0, R1 - X1:Y1, COLOR BY FOREGROUND COLOR
@.ENDDESC
.GLOBAL LCD_DrawLine
LCD_DrawLine:
    PUSH {R0-R6,LR}
     SUB R2, R1, R0  @ {X1:Y1} - {X0:Y0} = {dX':dY} dx' = dx (if dY>=0) | dx' = (dx-1) (if dY<0)

     UBFX R3, R2, #16, #16    @  R3 = dX'
     BFC R2, #16, #16         @  R2 = dY

     SXTH R2, R2
     ADDS R2, 0
     ITT MI          @ if dy < 0
          ADDMI R3, 1  @ then dX' = dX - 1 -> R3 = dx' + 1
          RSBMI R2, 0  @ R2 = |dy| [R2 = |Y1-Y0|
     SXTH R3, R3
     ADDS R3, 0
     IT MI
          RSBMI R3, 0 @ R3 = |dx|
     @ABS(y1 - y0) > ABS(x1 - x0)
     CMP R2, R3    @ dy - dx (if same result = 0 Z = 1 , if greater result > 0 Z=0, N=0, if lesser  result < 0 Z=0, N=1)
     @steep = dy>dx
     ITEE HI
          MOVHI R4, #1       @ steep = 1
          MOVLS R4, #0       @ steep = 0
          BLS DrawLine_dY_dX @ if dy<=dx
          @ X0 swap Y0
          ROR R0, R0, #16    @ X0:Y0 -> Y0:X0
          @ X1 swap Y1
          ROR R1, R1, #16    @ X1:Y1 -> Y1:X1
          @swap deltas
          MOV R5, R3
          MOV R3, R2
          MOV R2, R5
DrawLine_dY_dX:
     UBFX R5, R0, #16, #16  @ R5 = X0
     UBFX R6, R1, #16, #16  @ R6 = X1
     CMP R5, R6
     BLS DrawLine_X1_X0
     @swap start point and end point
     MOV R5, R1
     MOV R1, R0
     MOV R0, R5
DrawLine_X1_X0:
     @ SWAP R0 -> X1,X0; R1 -> Y1,Y0
     ROR R0, R0, #16 @ Y0:X0
     ROR R1, R1, #16 @ Y1:X1
     UBFX R5, R0, #16, #16   @ R5 = 00:Y0
     BFI R0, R1, #16, #16    @ R0 = X1:X0
     BFI R1, R5, #0, #16     @ R1 = Y1:Y0

     LSR R5, R3, 1           @ R5 = ERR = dX/2
     UBFX R6, R1, #16, #16   @ R6 = Y1
     BFC R1, #16, #16        @ R1 = Y0
     CMP R1, R6
     @IF Y1>Y0
     MOV R6, #-1      @ YSTEP = 1
     IT LT            @ ELSE
          RSBLT R6, 0 @ YSTEP = -1

     @ R0 - X1:X0, R1 - Y0, R2 - dY, R3 - dX, R4 - STEEP, R5 - ERR, R6 - YSTEP
     CMP R4, #1
     UBFX R4, R0, #16,#16     @R4 - X1
     BFC R0, #16, #16         @R0 - X0
     BNE DrawLine_Loop1       @if (steep) {
     B DrawLine_Loop2
DrawLine_Loop1:
     @ R0, R1 - AS IS
     BL LCD_DrawPixel       @DrawPixel(x0, y0, color); }

     SUBS R5, R2            @ERR -= dY
     BPL DrawLine_ERR1       @ IF ERR>=0 CONTINUE;
     @IF ERR < 0
     ADD R1, R6             @        y0 += ystep;
     ADD R5, R3             @        err += dX
DrawLine_ERR1:

     ADD R0, 1
     CMP R4, R0
     BNE DrawLine_Loop1
     B DrawLine_Ret
DrawLine_Loop2:
     @ R0, R1 - REVERSE ORDER
     BFI R1, R0, #16, #16  @ R1 X0:Y0
     MOV R0, R1           @ R0 X0:Y0
     LSR R1, R1, #16      @ R1 00:X0
DrawLine_LoopRev:
     @ R0, R1 - AS IS
     BL LCD_DrawPixel       @DrawPixel(x0, y0, color); }

     SUBS R5, R2            @ERR -= dY
     BPL DrawLine_ERR2       @ IF ERR>=0 CONTINUE;
     @IF ERR < 0
     ADD R0, R6             @        y0 += ystep;
     ADD R5, R3             @        err += dX
DrawLine_ERR2:

     ADD R1, 1
     CMP R4, R1
     BNE DrawLine_LoopRev
DrawLine_Ret:
     POP {R0-R6,LR}
     BX LR

@.DESC    name=LCD_DrawRect type=proc
@         Draw rectangle to the screen
@         IN: R0 - first point, R1 - second point, COLOR  is foreground color
@.ENDDESC
.global LCD_DrawRect
LCD_DrawRect:
     push {r0,r1,r5,r6,lr}
     MOV R6, R1
     BFI R1, R0, #0, #16 @ R1 - X1:Y0
     BL LCD_DrawLine
     MOV R5,R0  @ R5 - X0:Y0
     MOV R0, R1 @ R0 - X1:Y0
     MOV R1, R6 @ R1 - X1:Y1
     BL LCD_DrawLine
     MOV R0, R1 @ R0 - X1:Y1
     ROR R5, R5, #16 @ R5 - Y0:X0
     BFI R1, R5, #16, #16 @ R1 - X0:Y1
     BL LCD_DrawLine
     MOV R0, R1
     ROR R5, R5, #16
     MOV R1, R5
     BL LCD_DrawLine
     pop  {r0,r1,r5,r6,lr}
     bx lr

@ R0 - centre, R1 - radius, color - foregroung colo
.global LCD_DrawCircle
LCD_DrawCircle:
     push {r0-r6,lr}
     SUB SP, 20
     STR r0, [SP]
     @ +0 - y0,x0; +4 y,x; +8 -y,-x
@     void ST7789_DrawCircle(uint16_t x0, uint16_t y0, uint8_t r, uint16_t color)
@{
@     int16_t f = 1 - r;
      RSB r2, r1, #1  @
@     int16_t ddF_x = 1;\
      MOV R3, #1
@     int16_t ddF_y = -2 * r;
      MOV R4, R1, LSL 1
      RSB R4, 0
      MOV R5, R0, ROR 16
@     ST7789_DrawPixel(x0, y0 + r, color);

      ROR R5, R0, #16   @ R5 - Y0:X0
      BFI R1, R1, #16, #16   @ R1 - R:R
      MOV R6, R1
      ADD R0, R5, R6
      SUB R1, R5, R6
      TST R1, 0x8000
      IT NE
          ADDNE R1, 0x10000
      STR R0,[SP,4]   @ +4 X0+R,Y0+R
      STR R1,[SP,8]   @ +8 X0-R,Y0-R

      LDRH R0, [SP,2] @ X0
      LDRH R1, [SP,6] @ Y0+R
      BL LCD_DrawPixel
@     ST7789_DrawPixel(x0, y0 - r, color);
      LDRH R0, [SP,2] @ X0
      LDRH R1, [SP,10] @ Y0-R
      BL LCD_DrawPixel
@     ST7789_DrawPixel(x0 + r, y0, color);
      LDRH R0, [SP,4] @ X0+r
      LDRH R1, [SP] @ Y0
      BL LCD_DrawPixel
@     ST7789_DrawPixel(x0 - r, y0, color);
      LDRH R0, [SP,8] @ X0-r
      LDRH R1, [SP] @ Y0
      BL LCD_DrawPixel
      STR R5, [SP]
@     while (x < y) {
      @     int16_t x = 0;
      @     int16_t y = r;
      UBFX r5, R6, #0, #16   @R5 - R:0
      LSL R5, R5, #16
      @STR r5,[SP,4]
DrawCircle_Loop:
@          if (f >= 0) {
      CMP R2, 0
      ITTT PL
@               y--;
          SUBPL R5, #0x10000
@               ddF_y += 2;
          ADDPL R4, #2
@               f += ddF_y;
          ADDPL R2, R4
@          }
@          x++;
      ADD R5, #1
@          ddF_x += 2;
      ADD R3, #2
@          f += ddF_x;
      ADD R2, R3
      MOV R6, R0
      @STR R5, [SP,4]
      RSB R6, R5, 0
      TST R6, 0x8000
      IT NE
          ADDNE R6, 0x10000
      LDR R0, [SP]
      MOV R1, R0
      ADD R0, R5      @ Y0+Y:X0+X
      ADD R1, R6  @ Y0-Y:X0-X
      @ STACK_POINTER:LOW +4 X0+X:+6 Y0+Y:+8 X0-X: +10 Y0-Y HI
      STR R0, [SP,4]
      STR R1, [SP, 8]

      LDR R0, [SP]
      MOV R1, R0
      ADD R0, R0, R5, ROR 16
      ADD R1, R1, R6, ROR 16
      @ STACK_POINTER:LOW  +12 X0+Y:+14 Y0+X:+16 X0-Y:+18 Y0-X HI
      STR R0, [SP, 12]
      STR R1, [SP, 16]

@     ST7789_DrawPixel(x0 + x, y0 + y, color);
      LDRH R0,[SP,4]
      LDRH R1,[SP,6]
      BL LCD_DrawPixel
@     ST7789_DrawPixel(x0 + x, y0 - y, color);
      LDRH R0,[SP,4]
      LDRH R1,[SP,10]
      BL LCD_DrawPixel
@          ST7789_DrawPixel(x0 - x, y0 + y, color);
      LDRH R0,[SP,8]
      LDRH R1,[SP,6]
      BL LCD_DrawPixel
@          ST7789_DrawPixel(x0 - x, y0 - y, color);
      LDRH R0, [SP,8]
      LDRH R1, [SP,10]
      BL LCD_DrawPixel
@          ST7789_DrawPixel(x0 + y, y0 + x, color);
      LDRH R0, [SP, 12]
      LDRH R1, [SP, 14]
      BL LCD_DrawPixel
@          ST7789_DrawPixel(x0 - y, y0 + x, color);
      LDRH R0, [SP, 16]
      LDRH R1, [SP, 14]
      BL LCD_DrawPixel
@          ST7789_DrawPixel(x0 + y, y0 - x, color);
      LDRH R0, [SP, 12]
      LDRH R1, [SP, 18]
      BL LCD_DrawPixel
@          ST7789_DrawPixel(x0 - y, y0 - x, color);
      LDRH R0, [SP, 16]
      LDRH R1, [SP, 18]
      BL LCD_DrawPixel
@     }
@     ST7789_UnSelect();
@}
     UBFX R1, R5, #0, #16 @ R1 - X
     UBFX R6, R5, #16, #16 @ R6 - Y
     CMP R6, R1
     BGT  DrawCircle_Loop
     ADD SP, 20
     pop {r0-r6,lr}
     BX LR

.global LCD_FillCircle
LCD_FillCircle:
     push {r0-r6,lr}
     SUB SP, 20
     STR r0, [SP]
@     int16_t f = 1 - r;
      RSB r2, r1, #1  @
@     int16_t ddF_x = 1;\
      MOV R3, #1
@     int16_t ddF_y = -2 * r;
      MOV R4, R1, LSL 1
      RSB R4, 0
      MOV R5, R0, ROR 16

      ROR R5, R0, #16   @ R5 - Y0:X0
      BFI R1, R1, #16, #16   @ R1 - R:R
      MOV R6, R1
      ADD R0, R5, R6
      SUB R1, R5, R6
      TST R1, 0x8000
      IT NE
          ADDNE R1, 0x10000
      STR R0,[SP,4]   @ +4 X0+R,Y0+R
      STR R1,[SP,8]   @ +8 X0-R,Y0-R

      LDRH R0, [SP,2] @ X0
      LDRH R1, [SP,6] @ Y0+R
      BL LCD_DrawPixel
@     DrawPixel(x0, y0 - r)
      LDRH R0, [SP,2] @ X0
      LDRH R1, [SP,10] @ Y0-R
      BL LCD_DrawPixel
@     DrawPixel(x0 + r, y0)
      LDRH R0, [SP,4] @ X0+r
      LDRH R1, [SP] @ Y0
      BL LCD_DrawPixel
@     DrawPixel(x0 - r, y0)
      LDRH R0, [SP,8] @ X0-r
      LDRH R1, [SP] @ Y0
      BL LCD_DrawPixel
      STR R5, [SP]
@     while (x < y) {
      @     x = 0;
      @     y = r;
      UBFX r5, R6, #0, #16   @R5 - R:0
      LSL R5, R5, #16
      @STR r5,[SP,4]
FillCircle_Loop:
@          if (f >= 0) {
      CMP R2, 0
      ITTT PL
@               y--;
          SUBPL R5, #0x10000
@               ddF_y += 2;
          ADDPL R4, #2
@               f += ddF_y;
          ADDPL R2, R4
@          }
@          x++;
      ADD R5, #1
@          ddF_x += 2;
      ADD R3, #2
@          f += ddF_x;
      ADD R2, R3
      MOV R6, R0
      @STR R5, [SP,4]
      RSB R6, R5, 0
      TST R6, 0x8000
      IT NE
          ADDNE R6, 0x10000
      LDR R0, [SP]
      MOV R1, R0
      ADD R0, R5      @ Y0+Y:X0+X
      ADD R1, R6  @ Y0-Y:X0-X
      @ STACK_POINTER:LOW
@    +4  X0+X
@    +6  Y0+Y
@    +8  X0-X
@    +10 Y0-Y
      STR R0, [SP,4]
      STR R1, [SP, 8]

      LDR R0, [SP]
      MOV R1, R0
      ADD R0, R0, R5, ROR 16
      ADD R1, R1, R6, ROR 16
      @ STACK_POINTER:LOW
@    +12  X0+Y:
@    +14  Y0+X:
@    +16  X0-Y:
@    +18  Y0-X
      STR R0, [SP, 12]
      STR R1, [SP, 16]

      @DrawLine(x0 - x, y0 + y, x0 + x, y0 + y)
      LDRH R0,[SP, 6]       @ 0:Y0+Y
      MOV R1, R0            @ 0:Y0+Y
      LDRH R6, [SP, 8]      @ 0:X0-X
      BFI R0, R6, #16, #16  @ X0-X:Y0+Y
      LDRH R6, [SP, 4]      @ 0:X0+X
      BFI R1, R6, #16, #16  @ X0+X:Y0+Y
      BL LCD_DrawLine
      @DrawLine(x0 + x, y0 - y, x0 - x, y0 - y)
      LDRH R0,[SP, 10]      @ 0:Y0-Y
      MOV R1, R0            @ 0:Y0-Y
      LDRH R6, [SP, 4]      @ 0:X0+X
      BFI R0, R6, #16, #16  @ X0+X:Y0-Y
      LDRH R6, [SP, 8]      @ 0:X0-X
      BFI R1, R6, #16, #16  @ X0-X:Y0-Y
      BL LCD_DrawLine
      @DrawLine(x0 + y, y0 + x, x0 - y, y0 + x)
      LDRH R0,[SP, 14]      @ 0:Y0+X
      MOV R1, R0            @ 0:Y0+X
      LDRH R6, [SP, 12]      @ 0:X0+Y
      BFI R0, R6, #16, #16  @ X0+Y:Y0+X
      LDRH R6, [SP, 16]      @ 0:X0-Y
      BFI R1, R6, #16, #16  @ X0-Y:Y0+X
      BL LCD_DrawLine
      @DrawLine(x0 + y, y0 - x, x0 - y, y0 - x)
      LDRH R0,[SP, 18]      @ 0:Y0-X
      MOV R1, R0            @ 0:Y0-X
      LDRH R6, [SP, 12]      @ 0:X0+Y
      BFI R0, R6, #16, #16  @ X0+Y:Y0+X
      LDRH R6, [SP, 16]      @ 0:X0-Y
      BFI R1, R6, #16, #16  @ X0-Y:Y0+X
      BL LCD_DrawLine

     UBFX R1, R5, #0, #16 @ R1 - X
     UBFX R6, R5, #16, #16 @ R6 - Y
     CMP R6, R1
     BGT  FillCircle_Loop
     ADD SP, 20
     pop {r0-r6,lr}
     BX LR

.global LCD_FillRect
LCD_FillRect:
     push {r0-r6,lr}
     @ R0 - left corner      XS:YS
     @ R1 - width:height
     @ fill buffer 2kB
     @ if size of filling greter - make dubble send buffer
     ADD R2, R0, R1                @ R2 - XS+W:YS+H
     MOV R3, R2
     MOVT R3, CANVAS_WIDTH         @ R3 - CANVAS_WIDTH:YS+H
     CMP R2, R3                    @ XS+W:YS+H - CANVAS_WIDTH:YS+H = dw:0
     IT PL
          MOVTPL R1, CANVAS_WIDTH
     ROR R2, R2, #16               @ R2 - YS+H:XS+W   | YE:XE
     MOV R3, R2
     MOVT R3, CANVAS_HEIGHT        @ R3 - CANVAS_HEIGHT:XS+W
     CMP R2, R3                    @ YS+H:XS+W - CANVAS_HEIGHT:XS+W = dh:0
     ITT PL
          RORPL R3, R3, #16        @ R3 - XS+W:CANVAS_HEIGHT
          BFIPL R1, R3, #0, #16    @ R1 - *:CANVAS_HEIGHT
     ADD R2, R0, R1                @ R2 - XE:YE
     MOV R3, R1                    @ R3 - width:height
     MOV R1, R2                    @ R1 - XE:YE
     BFI R2, R0, #16, #16          @ R2 - YS:YE
     LSR R1, R1, #16               @ R1 - 0:XE
     BFI R0, R1, #0, #16           @ R0 - XS:XE
     UBFX R1, R3, #16, #16         @ R1 - hhwR1 <width>
     BFC R3, #16, #16              @ R3 - lhwR1 <height>
     MUL R3, R1                    @ R3 *= R1 - <square>
     MOV R1, R2                    @ R1 - YS:YE
     BL LCD_SetViewport
     @ 1) if square<2400 -> step 6
     @ 2) if square>2400 -> step 3
     @ 3) square /= 2
     @ 4) counter += 2
     @ 5) -> step 1
     @ 6) make color filled buffer square size
     @ 7) send bulk counter times
     MOV R6, 1
     MOV R4, R3
FR_step1:
     CMP R3, #2400
     BLS FR_step6
FR_step2:
     LSR R3, R3, 1
     LSL R6, R6, 1
     B FR_step1
FR_step6:
     BFI R4, R6, #16, #16
     MOV R0, R3
     MOV R1, 1
     LDR R2, =GL_FOREGROUND_COLOR
     LDR R2, [R2]
     BL GetFilledArray
     BL SendParameters
     MOV R0, R5
     BL ReleaseArray
     UBFX R6, R4, #16, #16
     BFC R4, #16, #16
     MUL R3, R6
     SUB R4, R3
     CMP R4, 0
     BEQ FR_RETURN
     MOV R0, R4
     BL GetFilledArray
     BL SendParameters
     MOV R0, R5
     BL ReleaseArray
FR_RETURN:
     pop {r0-r6,lr}
     BX LR

PreZeroes:
     push {R1, lr}
          MOV R1, 32
          cbz r0, PreZeroes_Exit
          MOV R1, 1
          LSR R0, R0, #16
          cbnz r0, PreZeroes_0
               ADD R1, 16
               LSL R0, R0, #16
PreZeroes_0:
          LSR R0, R0, #24
          cbnz r0, PreZeroes_1
               ADD R1, 8
               LSL R0, R0, #8
PreZeroes_1:
          LSR R0, R0, #28
          cbnz r0, PreZeroes_2
               ADD R1, 4
               LSL R0, R0, #4
PreZeroes_2:
          LSR R0, R0, #30
          cbnz r0, PreZeroes_3
               ADD R1, 2
               LSL R0, R0, #2
PreZeroes_3:
          LSR R0, R0, 31
          SUB R1, R0
PreZeroes_Exit:
     MOV r0, r1
     pop {R1, lr}
     bx lr
@ R0 - Coords, R1 - char code
.global LCD_MonoChar
LCD_MonoChar:
     push {r0-r6, lr}
          LDR R4, =GL_PAR
          LDR R3, [R4, GL_FONT-GL_PAR]
          LDR R5, [R3, 8]
          ORR R5, 1
          MOV R2, R4   @ R2 - GL struct pointer
          BLX R5       @ CALL mono buffer subroutine R1 - chcode, R2 - gl struct
          @ R1 - buffer address
          MOV R5, R1
          @ R3 - font obj, R2 - gl struct, R0 - coord, R5 - char image. Free: R1, R4
          UBFX R1, R0, #0, #16  @ R1 0:YS
          BFI R1, R1, #16, #16  @ R1, Ys:Ys
          LDRH R4, [R3, 2]       @font height
          ADD R1, R4
          SUB R1, 1
          LSR R0, R0, #16        @R0 - 0:XS
          BFI R0, R0, #16, #16   @ R0 - Xs:XS
          LDRH R4, [R3]          @font width
          ADD R0, R4
          SUB R0, 1
          BL LCD_SetViewport
          MOV R6, 0
          BL SendParameters
          MOV R0, R5
          BL ReleaseArray
     pop  {r0-r6, LR}
     BX LR

.global LCD_PropChar
LCD_PropChar:
     push {r0,r1,r3-r6, lr}
          LDR R4, =GL_PAR
          LDR R3, [R4, GL_FONT-GL_PAR]
          LDR R5, [R3, 12]
          ORR R5, 1
          MOV R2, R4   @ R2 - GL struct pointer
          BLX R5       @ CALL mono buffer subroutine R1 - chcode, R2 - gl struct
          @ R1 - buffer address @ r2 - char width
          MOV R5, R1
          @ R3 - font obj, R2 - gl struct, R0 - coord, R5 - char image. Free: R1, R4
          UBFX R1, R0, #0, #16  @ R1 0:YS
          BFI R1, R1, #16, #16  @ R1, Ys:Ys
          LDRH R4, [R3, 2]       @font height
          ADD R1, R4
          SUB R1, 1
          LSR R0, R0, #16        @R0 - 0:XS
          BFI R0, R0, #16, #16   @ R0 - Xs:XS
          @LDRH R4, [R3]          @font width
          ADD R0, R2
          SUB R0, 1
          BL LCD_SetViewport
          MOV R6, 0
          BL SendParameters
          MOV R0, R5
          BL ReleaseArray
     pop  {r0,r1,r3-r6, lr}
     BX LR

@ R0 - position, R1 - string pointer
.global LCD_Print
LCD_Print:
     PUSH {r0-r7,LR}
     MOV R6, R1
     LDR R2, =GL_FONT
     LDR R5, =CANVAS_WIDTH
     LDR R3, [R2, GL_FONT_MODE-GL_FONT]
     LDR R2, [R2]                            @font
     CMP R3, 0
     UBFX R3, R0, #16, #16                   @ string screen length counter prin from position
     BNE Print_Proportional

Print_Monospace:
     LDRH R4, [R2]         @getCharWidth
     LDRH R2, [R2,2]       @getCharHeight
     @EOR R6, R6

PrintMonoLoop:
     LDRB R1, [R6]     @getChar
     CMP R1, 0
     BEQ Print_Exit
     ADD R3, R4
     CMP R3, R5
     BMI PrintMonoLoop_less
     CMP R1, 32
     BEQ PrintMonoLoop_less
     ADD R0, R2          @ X:Y+CHAR_HEIGHT
     BFC R0, #16, #16    @ new line
     MOV R3, R4
     PrintMonoLoop_less:
     BL LCD_MonoChar
     ADD R6, 1
     ADD R0, R0, R4, lsl #16 @ X+=CHAR_WIDTH:Y
     B PrintMonoLoop
     POP {r0-r7,LR}
     BX LR

Print_Proportional:
     LDRH R4, [R2, 2]         @getCharHeight
     @EOR R6, R6
PrintPropLoop:
     LDRB r1, [R6]
     CMP R1, 0
     BEQ Print_Exit
     LDR R2, =GL_FONT
     LDR R2, [R2]
     LDR R2, [R2, 16]
     ORR R2, 1
     BLX R2                   @ GetCharWidth(R1=char) : R2 - width
     ADD R3, R2
     CMP R3, R5
     BMI PrintPropLoop_less
     CMP R1, 32
     BEQ PrintPropLoop_less
     ADD R0, R4          @ X:Y+CHAR_HEIGHT
     BFC R0, #16, #16    @ new line
     MOV R3, R2
PrintPropLoop_less:
     BL LCD_PropChar
     ADD R6, 1
     ADD R0, R0, R2, lsl #16
     B PrintPropLoop
Print_Exit:
     POP {r0-r7,LR}
     BX LR
@R0 - coord, R1 - image pointer, R2 - W:H
.global LCD_DrawImage
LCD_DrawImage:
     push {r0-r6,lr}
     MOV R3, R1
     UBFX R1, R0, #0, #16   @ 0:Y0
     ROR R0, R0, #16        @ Y0:X0
     BFI R1, R1, #16, #16   @ Y0:Y0
     BFI R0, R0, #16, #16   @ X0:X0
     UBFX R4, R2, #16, #16  @ 0:W
     BFC R2, #16, #16       @ 0:H
     ADD R0,R4
     SUB R0, 1
     ADD R1,R2
     SUB R1, 1
     BL LCD_SetViewport
     MOV R5, R3
     EOR R6, R6
     BL SendParameters
     pop {r0-r6,lr}
     BX LR


