@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор
.include "/src/inc/st7789v.inc"
.include "/src/inc/utils.inc"

.section .asmcode
@.DESC      name=GetCharSizeArray type=proc
@              Give pointer to array with sizes of chars of string
@ IN: R1 - pointer to string
@ OUT: R2 - pointer to array
@.ENDDESC
.global GetCharSizeArray
GetCharSizeArray:
     push {r0, r1, r3-r8, lr}
     EOR r5, r5
     BL GetStringLength
     CBZ R2, GetCharSizeArray_Exit
     MOV R0, R2
     MOV r3, R1
     MOV r1, #0
     BL GetArray
     EOR R0,R0
     LDR R4, =GL_PAR
     LDR R6, [R4, #8]    @FONT
     LDR R7, [R4, #12]   @FONT_MODE
     LDR R8, [R6, #16]   @FONT.GetCharWidth
     ORR r8, 1
GetCharSizeArray_Loop:
     LDRB R1, [R3, R0]
     CBZ R1, GetCharSizeArray_Exit
     CMP R7, 0
     ITE EQ
          LDRHEQ R2, [R6] @FONT_CHAR_WIDTH  if mode 0 char width = font_char_width
          BLXNE R8        @ else getcharwidth
     STRB R2, [R5, R0]
     ADD R0, 1
     B GetCharSizeArray_Loop
GetCharSizeArray_Exit:
     MOV R2, R5
     pop {r0, r1, r3-r8, lr}
     bx lr

.global GetStringLength
GetStringLength:
     push {r0,r1,lr}
          EOR r2,r2
GetStringLength_loop:
          LDRB R0, [R1,R2]
          CBZ R0, GetStringLength_Exit
          ADD R2, 1
          B GetStringLength_loop
GetStringLength_Exit:
     pop  {r0,r1,lr}
     bx lr


