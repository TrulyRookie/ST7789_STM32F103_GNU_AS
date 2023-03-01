@.CharSet=CP1251
@GNU AS

@********Rotation********
@ NORMAL:             MV=0,MX=0,MY=0
@ FLIP_NORMAL:        MV=0,MX=0,MY=1
@ CLOCKWISE_90:       MV=1,MX=1,MY=0
@ ANITCLOCKWISE_90:   MV=1,MX=0,MY=1
@  7   6   5   4   3    2  1  0
@  my  mx  mv  ml  rgb  mh -  -
@.ITEM ST7789 Display normal resolution
.equ DISP_WIDTH, 240
.equ DISP_HEIGHT, 320
@.end

@.ITEM ST7789 Display Orientation
.equ ORIENT_NORMAL,           0x00    @resolution normal
.equ ORIENT_FLIP_NORMAL,      0x80    @resolution normal
.equ ORIENT_CLOCCKWISE_90,    0x60    @transposed resolution
.equ ORIENT_ANTICLOCKWISE_90, 0xA0    @transposed resolution
@.END

 .equ ST7789_ROTATION, 0
@ .equ ST7789_ROTATION, 1
@ .equ ST7789_ROTATION, 2
@ .equ ST7789_ROTATION, 3

@====PARAMETERS====
     @           7 6  5  4  3 2  1  0
     @1 byte XS  0 D6 D5 D4 0 D2 D1 D0
     @ D7 - Set to ‘0’
     @ D6,D5,D4 - RGB interface color format 101 = 65K of RGB interface
     @                                       110 = 262K of RGB interface
     @ D3 - Set to ‘0’
     @ D2,D1,D0 - Control interface color format 011 = 12bit/pixel
     @                                           101 = 16bit/pixel
     @                                           110 = 18bit/pixel
     @                                           111 = 16M truncated
@.ITEM ST7789 Color mode
.equ RGB_65K_12BIT , 0x53
.equ RGB_65K_16BIT , 0x55
.equ RGB_65K_18BIT , 0x56
.equ RGB_65K_16M   , 0x57

.equ RGB_262K_12BIT , 0x63
.equ RGB_262K_16BIT , 0x65
.equ RGB_262K_18BIT , 0x66
.equ RGB_262K_16M   , 0x67
@.end

.if ST7789_ROTATION == 0
     .equ CANVAS_WIDTH, DISP_WIDTH
     .equ CANVAS_HEIGHT, DISP_HEIGHT
     .equ DISP_ORIENTATION, ORIENT_NORMAL
.endif
.if ST7789_ROTATION == 1
     .equ CANVAS_WIDTH, DISP_WIDTH
     .equ CANVAS_HEIGHT, DISP_HEIGHT
     .equ DISP_ORIENTATION, ORIENT_FLIP_NORMAL
.endif
.if ST7789_ROTATION == 2
     .equ CANVAS_WIDTH, DISP_HEIGHT
     .equ CANVAS_HEIGHT, DISP_WIDTH
     .equ DISP_ORIENTATION, ORIENT_CLOCCKWISE_90
.endif
.if ST7789_ROTATION == 3
     .equ CANVAS_WIDTH, DISP_HEIGHT
     .equ CANVAS_HEIGHT, DISP_WIDTH
     .equ DISP_ORIENTATION, ORIENT_ANTICLOCKWISE_90
.endif


.macro ABS reg
     TEQ \reg, \reg
     ITT MI
     MVNMI \reg, \reg
     ADDMI \reg, #1
.endm



