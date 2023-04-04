@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор
.include "/src/inc/st7789v.inc"
.include "/src/inc/gpio.inc"
.include "/src/inc/utils.inc"

.section .asmcode
@ основна€ программа
.global Start
Start:
     .if (PROFILING_IS_ON == 1)
          @ SCB_DEMCR |= CoreDebug_DEMCR_TRCENA_Msk; // разрешаем использовать DWT
          LDR r0, =SCB_DEMCR
          LDR r1, [r0]
          LDR r2, =CoreDebug_DEMCR_TRCENA
          ORR r1, r2
          STR r1, [r0]
     .endif
     EOR r11,r11
     MOV r12, #1
     LDR r0, =_BSS_START
     LDR r1, =_BSS_END
     EOR r2,r2
BBS_CLEAR_LOOP:
     CMP r0, r1
     BEQ BSS_REGION_END
     STR r2, [r0], #4
     B BBS_CLEAR_LOOP

BSS_REGION_END:
     BL SYSCLK72         @ включить тактирование от внешнего кварца на 72ћ√ц
     BL SYSTICK_INIT     @ настройка системного таймера
     LDR r0, =(CLOCK_AFIO|CLOCK_GPIOA|CLOCK_GPIOB)
     BL GPIO_ClockON
     BL SPI1_Init        @ включить SPI1
     BL LCD_Init         @ настроить дисплей
     EOR R0, R0
     BL SetPaper
MAIN_LOOP:
     MOV r4, r11
     MOV r5, r4
     MOV r6, r4
     MOV R1, R4
     MOV R0, R4
STAGE0:
     ADD r4, r12
     CMP R4, #31
     IT EQ
     ADDEQ R1, #1
     B DRAW
STAGE1:
     ADD r5, r12
     CMP R5, #63
     IT EQ
     ADDEQ R1, #1
     B DRAW
STAGE2:
     SUB r4, r12
     CMP R4, #0
     IT EQ
     ADDEQ R1, #1
     B DRAW
STAGE3:
     ADD r6, r12
     CMP R6, #31
     IT EQ
     ADDEQ R1, #1
     B DRAW
STAGE4:
     SUB r5, r12
     CMP R5, #0
     IT EQ
     ADDEQ R1, #1
     B DRAW
STAGE5:
     SUB R4, #1
     SUB R6, #1
     CMP R4, #0
     IT EQ
     ADDEQ R1, #1
     B DRAW

DRAW:
     BFI R0, R4, #11, #5
     BFI R0, R5, #5, #6
     BFI R0, R6, #0, #5

     @BL LCD_Clear
     @MVN R0, R0
     @BL Fract_Draw
     PUSH {R0-R2}
     @START_DWT_CHECK


     BL SetInk

     @MOV R0, 120
     @LSL R0, R0, #16
     @ADD R0, 160
     @MOV R1, 100
     @BL LCD_DrawCircle
     @BL DrawAstra
     @MOVW R0, 60    @Y
     @MOVT R0, 0    @X
     @MOVW R1, 200   @height
     @MOVT R1, 240   @width
     @BL LCD_FillRect
     @STOP_DWT_CHECK
     @POP {R0-R2}
     @BL PrintShit
     @BL PrintShitProp
     @BL PrintString1
     @BL PrintString2
     BL RescaleTest
     MOV R0, 100
     BL SYSTICK_DELAY
     @PUSH {R0-R2}
     @NEG R0, R0
     @BL SetInk
     @MOV R0, 120
     @LSL R0, R0, #16
     @ADD R0, 160
     @MOV R1, 80
     @BL LCD_DrawCircle
     @MOVW R0, 70    @Y
     @MOVT R0, 10    @X
     @MOVW R1, 180   @height
     @MOVT R1, 220   @width
     @BL LCD_FillRect
     POP {R0-R2}
     CMP R1, #0
     BEQ STAGE0
     CMP R1, #1
     BEQ STAGE1
     CMP R1, #2
     BEQ STAGE2
     CMP R1, #3
     BEQ STAGE3
     CMP R1, #4
     BEQ STAGE4
     CMP R1, #5
     BEQ STAGE0
     CMP R1, #6
     BEQ STAGE5
B MAIN_LOOP

@R0 - color
Fract_Draw:
PUSH {R0-R6,LR}
     MOV R3, R0
     MOV R0, 7*4
     MOV R1, 2
     MOV R2, 0
     BL GetFilledArray
                         @ R5 - allocated mem addr
                         @ +0 - I
                         @ +4 - J
                         @ +8 - K
                         @ +12 - COLOR
                         @ +16 - empty
                         @ +20 - XARR
                         @ +24 - YARR
     STR R3, [R5, 12]
     MOV R6, R5
     MOV R0, #16
     MOV R1, 2
     MOV R2, 0
     BL GetFilledArray @ make WORD X[16]
     STR R5, [R6, 20] @ XARR = &X[]
     BL GetFilledArray @ make WORD Y[16]
     STR R5, [R6, 24] @ YARR = &Y[]
     MOV R2, #0
FOR4_1:                  @FOR I=0 TO 3
     MOV R3, #0
     STR r3, [r6, 4]     @ J = 0
     FOR4_2:             @FOR J=0 TO 3
          @ 2 dem address in linear array
          LSL R0, R2, #2 @K=4*I
          ADD R0, R3     @K=4*I+J

          LDR R1, [r6, 20] @ R1 = *XARR  ;R1 = X[0]
          @ X[K] = J-2
          SUB R4, R3, #2           @ J-2
          STR R4, [R1,R0,lsl #2]   @ X[K]=J-2
          @ Y[K] = I-2
          LDR R1, [R6, 24]
          SUB R4, R2, #2           @ I-2
          STR R4, [R1,R0,lsl #2]   @ Y[K]=I-2

          ADD r3, #1
          CMP R3, #4
          BNE FOR4_2      @NEXT J
     ADD R2, #1
     CMP R2, #4
     BNE FOR4_1           @NEXT I

     LDR R1, [R6, 20]
     MOV R2, 0
     STR R2, [R1,1*4]   @ X[1] = 0
     MOV R2, 2
     STR R2, [R1,7*4]   @ X[7] = 2
     MOV R2, -3
     STR R2, [R1,8*4]   @ X[8] = -3
     MOV R2, -1
     STR R2, [R1,14*4]  @ x[14] = -1

     LDR R1, [R6, 24]
     MOV R2, -3
     STR R2, [R1,1*4]   @ Y[1] = -3
     MOV R2, 0
     STR R2, [R1,7*4]   @ Y[7] = 0
     MOV R2, -1
     STR R2, [R1,8*4]   @ Y[8] = -1
     MOV R2, 2
     STR R2, [R1,14*4]  @ Y[14] = 2

     MOV R0, 0       @ I
     STR R0, [R6, 0] @ I = 0
FOR16_I:
     MOV R0, 0
     STR R0, [R6, 4] @J=0
     FOR16_J:
          MOV R0, 0
          STR R0, [R6, 8]  @K=0
          FOR16_K:
            LDR R0, [R6, 0]        @ I
            LDR R1, [R6, 20]
            LDR r2, [r1,r0,lsl #2] @ X[I]
            LSL R2, R2, #4         @ X[I]*16

            LDR R0, [R6, 4]           @ J
            LDR R3, [r1,r0,lsl #2] @ X[J]
            LSL R3, R3, #2         @ X[J]*4
            ADD R2, R3             @ 16*X[I]+4*X[J]

            LDR R0, [R6, 8]       @ K
            LDR R0, [R1,R0,lsl #2] @ X[K]
            @LSL R0, R0, #2
            ADD R0, R2             @16*X[I]+4*X[J]+X[K]
     Y_CALC:
            PUSH {R0}
               LDR R0, [R6, 0]        @ I
               LDR R1, [R6, 24]       @ Y[0]
               LDR r2, [r1,r0,lsl #2] @ Y[I]
               LSL R2, R2, #4         @ Y[I]*16

               LDR R0, [R6, 4]           @ J
               LDR R3, [r1,r0,lsl #2] @ Y[J]
               LSL R3, R3, #2         @ Y[J]*4
               ADD R2, R3             @ 16*Y[I]+4*Y[J]

               LDR R0, [R6, 8]        @ K
               LDR R1, [R1,R0,lsl #2] @ Y[K]
               @LSL R1, R1, #2
               ADD R1, R2             @16*Y[I]+4*Y[J]+Y[K]
            POP {R0}
            RSB R0, R0, #50
            RSB R1, R1, #60
            LDR R2, [R6, 12]
            BL LCD_DrawPixel
          LDR R1, [R6, 8]
          ADD R1, #1
          CMP R1, #16
          ITT  NE
               STRNE  R1, [R6,8]
               BNE FOR16_K
     LDR R1, [R6, 4]
     ADD R1, #1
     CMP R1, #16
     ITT  NE
          STRNE  R1, [R6, 4]
          BNE FOR16_J
LDR R1, [R6]
ADD R1, #1
CMP R1, #16
ITT  NE
     STRNE  R1, [R6]
     BNE FOR16_I

     LDR R0, [r6, 24]
     BL ReleaseArray
     LDR R0, [R6, 20]
     BL ReleaseArray
     MOV r0, r6
     BL ReleaseArray
POP {R0-R6,LR}
BX LR

DrawAstra:
     push {r0-r6,lr}
     MOV R5, 120
     LSL R5, R5, #16
     MOV R6, 0
     MOV R3, 10 @ Step
     MOV R4, 0 @ counter
DA_Loop1:
     PUSH {r7}
     LDR R7, =0x007800A0
     ADD R0, R7, R5      @ for r5 from 120 to 0 step -10 + 120
     ADD R1, R7, R6      @ for r6 from 0 to 120 step 10 + 120
     POP {R7}
     BL LCD_DrawLine
     PUSH {r7}
     LDR R7, =0x007800A0
     RSB R0, R5, 0       @ R0 = -120
     TST R0, #0x8000
     ITTT NE
          RORNE R0, R0, #16
          ADDNE R0, #1
          RORNE R0, R0, #16
     ADD R0, R7          @ R0 = -120 + 120
     ADD R1, R7, R6
     POP {R7}
     BL LCD_DrawLine
     PUSH {r7}
     LDR R7, =0x007800A0
     ADD R0, R7, R5
     RSB R1, R6, 0       @ R1 = -120
     TST R1, #0x8000
     ITTT NE
          RORNE R1, R1, #16
          ADDNE R1, #1
          RORNE R1, R1, #16
     ADD R1, R7          @ R1 = -120 + 120
     POP {R7}
     BL LCD_DrawLine
     PUSH {r7}
     LDR R7, =0x007800A0
     RSB R0, R5, 0       @ R0 = -120
     ITTT NE
          RORNE R0, R0, #16
          ADDNE R0, #1
          RORNE R0, R0, #16
     ADD R0, R7          @ R0 = -120 + 120
     RSB R1, R6, 0       @ R0 = -120
     ITTT NE
          RORNE R1, R1, #16
          ADDNE R1, #1
          RORNE R1, R1, #16
     ADD R1, R7          @ R0 = -120 + 120
     POP {R7}
     BL LCD_DrawLine
     ROR R5, R5, #16
     SUB R5, R3
     ROR R5, R5, #16
     ADD R6, R3
     ADD R4, 1
     CMP R4, 13
     BNE DA_Loop1
     pop {r0-r6,lr}
     BX LR


PrintString1:
     push {r0-r5, lr}
     LDR R0, =font16x16_sys
     BL SetFont
     MOV R0, 1
     BL SetFontType
     LDR r1, =message
     LDR R0, =0x000A0040
     BL LCD_Print
     pop {r0-r5, lr}
     bx lr

PrintString2:
     push {r0-r5, lr}
     LDR R0, =font16x16_sys
     BL SetFont
     MOV R0, 0
     BL SetFontType
     LDR r1, =message
     LDR R0, =0x000A0080
     BL LCD_Print
     pop {r0-r5, lr}
     bx lr

message: .asciz  "Very-very big and so long and long string is suposed to be printed. And this shit is working!"


RescaleTest:
     push {R0-R6,lr}
     MOV R1, '0'
     MOV R0, 0
     BL LCD_PropChar
     LDR R2, =GL_PAR
     LDR R3, [R2, 8]
     LDR R0, [r3, 12]
     ORR r0, 1
     BLX R0         @font.GetPropBuffer(R1 = '0', R2 = *ST7789_GL)
     @R1 - *buffer, R2 - char_width
     MOV R0, R2, LSL #16
     LSL R4, R2, #1
     LSL R4, R4, #16     @ R4 W1=W0*2:0
     LDRH R2, [R3, 2]
     BFI R0, R2, #0, #16 @ R0 W0,H0
     push {r0}
     MOV R2, #32
     ORR R2, R4          @ R2 = W1:H1
     PUSH {r2}
     MOV R6, R2
     BL RescaleImage
     MOV R3, R1          @ source  img
     MOV R1, R2
     POP {R0}
     BL SmoothImage

     MOV R1, R2
     MOV R0, 18
     MOV R2, R6          @ scaled img
     BL LCD_DrawImage
     MOV R0, R1
     BL ReleaseArray     @release scaled img

     pop {r0}
     LDR R2, =0x00040008
     MOV R6, R2
     MOV R1, R3
     BL RescaleImage

     MOV R1, R2
     MOV R0, (18+32+3)
     MOV R2, R6          @ scaled img
     BL LCD_DrawImage
     MOV R0, R1
     BL ReleaseArray     @release scaled img

     MOV R0, R3
     BL ReleaseArray    @ release source img
     pop {r0-r6,lr}
     BX lr

