@.CharSet=CP1251
@GNU AS

.ifndef ST7789_INC
     .equ ST7789_INC, 1
.INCLUDE       "/src/inc/spi.inc"
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

@****************OPCODES*************************
@ SendData:  @ IN r0 - data byte, r1: 0 - command, 1 - data
.equ OP_NOP              ,0x00 @operation  NO PARAM
.equ OP_SWRESET          ,0x01 @software reset  NO PARAM
.equ OP_RDDID            ,0x04 @read display id (read) 0byte - dummy, 1..3bytes - data
.equ OP_RDDST            ,0x09 @read display status (read) 0byte - dummy, 1..3bytes - data
.equ OP_RDDPM            ,0x0A @read display power (read) 0byte - dummy, 1byte - data
.equ OP_RDDMADCTL        ,0x0B @read display (read) 0byte - dummy, 1byte - data
.equ OP_RDDCOLMOD        ,0x0C @read display status (read) 0byte - dummy, 1byte - data
.equ OP_RDDIM            ,0x0D @read display image (read) 0byte - dummy, 1byte - data
.equ OP_RDDSM            ,0x0E @read display signal (read) 0byte - dummy, 1byte - data
.equ OP_RDDSDR           ,0x0F @read display self-diagnostic result (read) 0byte - dummy, 1byte - data
.equ OP_SLPIN            ,0x10 @sleep in NO PARAM
.equ OP_SLPOUT           ,0x11 @sleep out NO PARAM
.equ OP_PTLON            ,0x12 @partial mode on NO PARAM
.equ OP_NORON            ,0x13 @partial off (normal) NO PARAM
.equ OP_INVOFF           ,0x20 @display inversion off NO PARAM
.equ OP_INVON            ,0x21 @display inversion on NO PARAM
.equ OP_GAMSET           ,0x26 @set gamma. IN: r0 - number of curve 1-4
.equ OP_DISPOFF          ,0x28 @display off NO PARAM
.equ OP_DISPON           ,0x29 @display on NO PARAM
.equ OP_CASET            ,0x2A @column address set r0 - XS (start) , r1 - XE (end)
.equ OP_RASET            ,0x2B @column address set r0 - XS (start) , r1 - XE (end)
.equ OP_RAMWR            ,0x2C @memory write 1...N bytes
.equ OP_RAMRD            ,0x2E @memory read (read) byte dummy 1...N bytes
.equ OP_PTLAR            ,0x30 @partial start/end address set 2bytes start  + 2bytes end
.equ OP_VSCRDEF          ,0x33 @vertical scrolling definition 6 bytes (3 parts by 2 bytes)
.equ OP_TEOFF            ,0x34 @tearing effect line off NO PARAM
.equ OP_TEON             ,0x35 @tearing effect line on 1byte with 1 bit
.equ OP_MADCTL           ,0x36 @memory data access control 1 byte
.equ OP_VSCRSADD         ,0x37 @vertical scrolling start address 2 bytes
.equ OP_IDMOFF           ,0x38 @iddle mode off NO PARAM
.equ OP_IDMON            ,0x39 @iddle mode on NO PARAM
.equ OP_COLMOD           ,0x3A @interface pixel format 1byte
.equ OP_RAMWRC           ,0x3C @memory write continue 1..N bytes
.equ OP_RAMRDC           ,0x3E @memory read continue  (read) 1byte dummy, 1..N Bytes
.equ OP_TESCAN           ,0x44 @set tear scanline 2 bytes
.equ OP_RDTESCAN         ,0x45 @read tear scanline 1byte dummy + 2bytes
.equ OP_WRDISBV          ,0x51 @write display brightness 1byte
.equ OP_RDDISBV          ,0x52 @read display brightness 1byte dummy + 1byte
.equ OP_WRCTRLD          ,0x53 @write CTRL display 1 byte
.equ OP_RDCTRLD          ,0x54 @read CTRL display 1 byte dummy + 1 byte
.equ OP_WRCACE           ,0x55 @write content adaptive brightness control and color enhancement 1byte
.equ OP_RDCABC           ,0x56 @read content adaptive brightness control 1byte dummy + 1byte
.equ OP_WRCABCMB         ,0x5E @write CABC minimum brightness 1 byte
.equ OP_RDCABCMB         ,0x5F @read CABC minimum brightness 1byte dummy + 1 byte
.equ OP_RDABCSDR         ,0x68 @read automatic brightness control self-diagnostic result 1byte dummy + 1byte
.equ OP_RDID1            ,0xDA @Read ID1 1byte dummy + 1 byte
.equ OP_RDID2            ,0xDB @Read ID2 1byte dummy + 1 byte
.equ OP_RDID3            ,0xDC @Read ID3 1byte dummy + 1 byte
.equ OP_PORCTRL          ,0xb2
.equ OP_GCTRL            ,0xb7
.equ OP_VCOMS            ,0xbb
.equ OP_LCMCTRL          ,0xC0
.equ OP_VDVVRHEN         ,0xC2
.equ OP_VRHS             ,0xC3
.equ OP_VDVS             ,0xC4
.equ OP_FRCTRL2          ,0xC6
.equ OP_PWCTRL1          ,0xD0
.equ OP_PVGAMCTRL        ,0xE0
.equ OP_NVGAMCTRL        ,0xE1
@************************************************


.macro ABS reg
     TEQ \reg, \reg
     ITT MI
     MVNMI \reg, \reg
     ADDMI \reg, #1
.endm

.endif
