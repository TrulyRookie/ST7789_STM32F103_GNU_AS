@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор
.include "/src/inc/st7789v.inc"
.include "/src/inc/utils.inc"

.section .asmcode
@ R1 - image array, R0 - W0:H0, R2 - W1:H1
@ R2 - rescaled image
@.DESC  name=RescaleImage type=proc
@       Image scaling procedure
@     IN:
@          R0 - source width:height
@          R1 - pointer to image
@          R2 - destination width:height
@     OUT:
@          R2 - pointer to scaled image
@.ENDDESC
.global RescaleImage
RescaleImage:
     push {r0,r1,r3-r10,lr}
     mov r3, r0
     mov r4, r1
     mov r5, r2
     UBFX R0, R2, #16, #16
     BFC R2, #16, #16
     MUL R0, R2
     MOV r1, 1
     mov r2, r5
     BL GetArray

     EOR R0, R0     @Y counter
RescaleImage_Loop1:
     UBFX R7, R3, #0, #16   @H0
     MUL R8, R0, R7     @ R8 = Y * H0
     UBFX R7, R2, #0, #16   @H1
     UDIV R8, R8, R7    @ R8 = Y*H0/H1 - Y0 coordinate
     EOR R1, R1     @X counter
RescaleImage_Loop2:
     UBFX R7, R3, #16, #16   @W0
     MUL R6, R1, R7     @ R6 = X * W0
     MOV R10, R7             @ W0
     UBFX R7, R2, #16, #16   @W1
     MUL R9, R0, R7          @ R9 = Y*W1
     ADD R9, R1              @ R9 = Y*W1+X
     LSL R9, R9, 1           @ R9 = 2*(Y*W1+X) - shift in dest array
     UDIV R6, R6, R7    @ R6 = X*W0/W1 - X0 coordinate
     MUL R10, R8, R10   @ R10 = Y0*W0
     ADD R10, R6        @ R10 = Y0*W0+X0
     LSL R10, R10, 1    @ R10 = 2*(Y0*W0+X0) - shift in source array
     LDRH R7, [R4,R10]  @ R7 = sourse[x0,y0]
     STRH R7, [R5,R9]   @ dest[x,y] = R7
     UBFX R7, R2, #16, #16
     ADD R1, #1
     CMP R1, R7
     BNE RescaleImage_Loop2  @ if x<W1 loop
     UBFX R7, R2, #0, #16
     ADD R0, 1
     CMP R0, R7
     BNE RescaleImage_Loop1 @ if y<h1 loop
     MOV R2, r5
     pop {r0,r1,r3-r10,lr}
     bx lr

@.DESC  name=SmoothImage type=proc
@       Image scaling procedure
@     IN:
@          R0 - source width:height
@          R1 - pointer to image
@     OUT:
@          R2 - pointer to scaled image
@.ENDDESC
.global SmoothImage
SmoothImage:
     push {r0,r1,r3-r9,lr}
     SUB SP, 16
     @ STACK_POINTER:
     @ +0 - R accumulator
     @ +4 - G accumulator
     @ +8 - B accumulator
     UBFX R2, R0, #0, #16 @ source height
     LSR R3, R0, #16      @ source width
     MUL R0, R3, R2       @ buffer size w*h
     MOV R4, R1
     MOV R1, 1
     BL GetArray
     @ R5 - destination array
     @ R4 - source array
     EOR R1,R1 @Y
SmoothImage_Loop_Y:
     @SUB R5, R1, 1
     @STR R5, [SP, 4]
     @ADD R5, R1, 1
     @STR R5, [SP, 12]
     EOR R0, R0 @ X
SmoothImage_Loop_X:
     STR R11, [SP]
     STR R11, [SP, 4]
     STR R11, [SP, 8]
     @SUB R5, R0, 1
     @STR R5, [SP]
     @ADD R5, R0, 1
     @STR R5, [SP,8]
     MOV R9, SP
@ (x-1;y-1)
     SUB R6, R0, #1
     SUB R7, R1, #1
     BL SmoothCheckAndGet
     BL SmoothAddRestore

@ (x;y-1)
     MOV R6, R0
     SUB R7, R1, #1
     BL SmoothCheckAndGet
     BL SmoothAddRestore

@ (x+1;y-1)
     ADD R6, R0, #1
     SUB R7, R1, #1
     BL SmoothCheckAndGet
     BL SmoothAddRestore

@ (x-1;y)
     SUB R6, R0, #1
     MOV R7, R1
     BL SmoothCheckAndGet
     BL SmoothAddRestore

@ (x+1;y)
     ADD R6, R0, #1
     MOV R7, R1
     BL SmoothCheckAndGet
     BL SmoothAddRestore

@ (x-1;y+1)
     SUB R6, R0, #1
     ADD R7, R1, #1
     BL SmoothCheckAndGet
     BL SmoothAddRestore

@ (x;y+1)
     MOV R6, R0
     ADD R7, R1, #1
     BL SmoothCheckAndGet
     BL SmoothAddRestore

@ (x+1;y+1)
     ADD R6, R0, #1
     ADD R7, R1, #1
     BL SmoothCheckAndGet
     BL SmoothAddRestore
     EOR R8, R8
     LDR R6, [SP] @SR
     LSR R6, R6, 3
     BFI R8, R6, #11, #5
     LDR R6, [SP,4] @SG
     LSR R6, R6, 3
     BFI R8, R6, #5, #6
     LDR R6, [SP,8] @SB
     LSR R6, R6, 3
     BFI R8, R6, #0, #5
     @ R8 - interpolated value
     MUL R6, R1, R3
     ADD R6, R0          @ Y*width+X
     LSL R6, R6, #1
     REV16 R8, R8
     STRH R8, [R5, R6]   @ store new image pixel

     ADD R0, 1
     CMP R0, R3
     BNE SmoothImage_Loop_X
     ADD R1, 1
     CMP R1, R2
     BNE SmoothImage_Loop_Y
     ADD SP, 16
     mov r2, r5
     pop {r0,r1,r3-r9,lr}
     bx lr

@ R4 - source img, R6 - x', R7 - y', R2 - height, R3 - width
SmoothCheckAndGet:
     push {r0-r7, LR}
     CMP R6, 0
     BMI SmoothCheck_OutOfRange @ if x'<0
     CMP R6, R3
     BGE SmoothCheck_OutOfRange @ if x'>=width
     CMP R7, 0
     BMI SmoothCheck_OutOfRange @ if y'<0
     CMP R7, R2
     BGE SmoothCheck_OutOfRange @ if y'>=width
     MUL R0, R7, R3
     ADD R0, R6                 @ index = y'*width+x'
     LSL R0, R0, #1             @ index *= 2
     LDRH R8, [R4, R0]          @ get img pixel color
     b SmoothCheck_Return_R8
SmoothCheck_OutOfRange:
     LDR R8, =GL_PAR
     LDR R8, [R8]      @ return background color
SmoothCheck_Return_R8:
     UBFX R0, R8, #11, #5  @R
     UBFX R1, R8, #5, #6   @G
     UBFX R2, R8, #0, #5   @B
     BFI R8, R0, #16, #8
     BFI R8, R1, #8, #8
     BFI R8, R2, #0, #8
     pop {r0-r7,LR}
     bx lr

     @R9 - local vars  R8 - data 00 RR GG BB
SmoothAddRestore:
     PUSH {r0 - r2, LR}
     UBFX R0, R8, #0, #8   @B
     UBFX R1, R8, #8, #8   @G
     LSR R8, R8, #16       @R
     LDR R2, [R9]
     ADD R2, R8
     STR R2, [R9]
     LDR R2, [R9, 4]
     ADD R2, R1
     STR R2, [R9, 4]
     LDR R2, [R9, 8]
     ADD R2, R0
     STR R2, [R9, 8]
     pop {r0 - r2, LR}
     BX LR


