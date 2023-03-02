@.CharSet=CP1251
@GNU AS

.syntax unified     @ ��������� ��������� ����
.thumb              @ ��� ������������ ���������� Thumb
.cpu cortex-m3      @ ���������

.include "/src/inc/st7789v.inc"
.include "/src/inc/spi.inc"

.section .asmcode

@ SendData:  @ IN r0 - data byte, r1: 0 - command, 1 - data
.global ST_NOP          @ 0x00 operation  NO PARAM
ST_NOP:
     push {r0,r1,LR}
          mov r0, #0
          mov r1, r0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_SWRESET      @ 0x01 software reset  NO PARAM
ST_SWRESET:
     push {r0,r1,LR}
          mov r0, #0x01
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_RDDID        @ 0x04 read display id (read) 0byte - dummy, 1..3bytes - data
ST_RDDID:
     BX LR

.global ST_RDDST        @ 0x09 read display status (read) 0byte - dummy, 1..3bytes - data
ST_RDDST:
     BX LR

.global ST_RDDPM        @ 0x0A read display power (read) 0byte - dummy, 1byte - data
ST_RDDPM:
     BX LR

.global ST_RDDMADCTL        @ 0x0B read display (read) 0byte - dummy, 1byte - data
ST_RDMADCTL:
     BX LR

.global ST_RDDCOLMOD        @ 0x0C read display status (read) 0byte - dummy, 1byte - data
ST_RDDCOLMOD:
     BX LR

.global ST_RDDIM        @ 0x0D read display image (read) 0byte - dummy, 1byte - data
ST_RDDIM:
     BX LR

.global ST_RDDSM        @ 0x0E read display signal (read) 0byte - dummy, 1byte - data
ST_RDDSM:
     BX LR

.global ST_RDDSDR        @ 0x0F read display self-diagnostic result (read) 0byte - dummy, 1byte - data
ST_RDDSDR:
     BX LR

.global ST_SLPIN         @ 0x10 sleep in NO PARAM
ST_SLPIN:
     push {r0,r1,LR}
          mov r0, #0x10
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_SLPOUT         @ 0x11 sleep out NO PARAM
ST_SLPOUT:
     push {r0,r1,LR}
          mov r0, #0x11
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_PTLON         @ 0x12 partial mode on NO PARAM
ST_PTLON:
     push {r0,r1,LR}
          mov r0, #0x12
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_NORON         @ 0x13 partial off (normal) NO PARAM
ST_NORON:
     push {r0,r1,LR}
          mov r0, #0x13
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_INVOFF         @ 0x20 display inversion off NO PARAM
ST_INVOFF:
     push {r0,r1,LR}
          mov r0, #0x20
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_INVON         @ 0x21 display inversion on NO PARAM
ST_INVON:
     push {r0,r1,LR}
          mov r0, #0x21
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_GAMSET
@ 0x26 set gamma. IN: r0 - number of curve 1-4
ST_GAMSET:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x26
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     push {r0,r1,LR}
          @====PARAMETERS====
          @ 7  6  5  4  3   2   1   0
          @ 0  0  0  0 CG3 GC2 GC1 GC0
          @ 01h - GC0 Gamma Curve 1 (G2.2)
          @ 02h - GC1 Gamma Curve 2 (G1.8)
          @ 04h - GC2 Gamma Curve 3 (G2.5)
          @ 08h - GC3 Gamma Curve 4 (G1.0)
          @ r0 - curve number
          MOV r1, #1
          SUB r0, r1
          LSR r0, r1, r0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_DISPOFF        @ 0x28 display off NO PARAM
ST_DISPOFF:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x28
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_DISPON         @ 0x29 display on NO PARAM
ST_DISPON:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x29
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR
@.DESC     name=ST_CASET type=proc
@ ***************************************************************************
@ *                  ��������� ������� ��������                             *
@ ***************************************************************************
@ | ���������:                                                              |
@ |  R0 - ���������� XS: 15:0                                               |
@ |  R1 - ���������� XE: 15:0                                               |
@ +-------------------------------------------------------------------------+
@.ENDDESC
.global ST_CASET
@ 0x2A column address set r0 - XS (start) , r1 - XE (end)
ST_CASET:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x2A
          mov r1, #0
          BL SendData
          @MOV r0, #4
          @MOV r1, #1
          @BL GetArray
     pop {r0,r1,LR}
          @====PARAMETERS====
          @               7    6    5    4    3    2    1   0
          @1 HI byte XS  xs15 xs14 xs13 xs12 xs11 xs10 xs9 xs8
          @2 LO byte XS  xs7  xs6  xs5  xs4  xs3  xs2  xs1 xs0
          @3 HI byte XE  xe15 xe14 xe13 xe12 xe11 xe10 xe9 xe8
          @4 LO byte XE  xe7  xe6  xe5  xe4  xe3  xe2  xe1 xe0
          @ -The value of XS [15:0] and XE [15:0] are referred when RAMWR command comes.
          @ -Each value represents one column line in the Frame Memory.
          push {r0-r5,LR}
               @REV16 R2, R0
               @MOV R0, R2
               @REV16 R2, R1
               @MOV R1, R2
               @strh r0, [r5]
               @strh r1, [r5,#2]
               @MOV r0, r5
               @BL DMA_Send
               @BL ReleaseArray
               MOV r3, r1
               MOV r2, r0
               UBFX r0, r2,  #8, #8
               MOV r1, r12
               BL SendData
               UBFX r0, r2, #0, #8
               BL SendData
               UBFX r0, r3, #8, #8
               BL SendData
               UBFX r0, r3, #0, #8
               BL SendData
          pop {r0-r5,LR}
     BX LR
@.DESC     name=ST_RASET type=proc
@ ***************************************************************************
@ *                  ��������� ������� ��������                             *
@ ***************************************************************************
@ | ���������:                                                              |
@ |  R0 - ���������� YS: 15:0                                               |
@ |  R1 - ���������� YE: 15:0                                               |
@ +-------------------------------------------------------------------------+
.global ST_RASET
@ 0x2B row address set 4bytes, r0 - YS (start) , r1 - YE (end)
ST_RASET:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x2B
          mov r1, #0
          BL SendData
          @MOV r0, #4
          @MOV r1, #1
          @BL GetArray
     pop {r0,r1,LR}
          @====PARAMETERS====
          @               7    6    5    4    3    2    1   0
          @1 HI byte YS  ys15 ys14 ys13 ys12 ys11 ys10 ys9 ys8
          @2 LO byte YS  ys7  ys6  ys5  ys4  ys3  ys2  ys1 ys0
          @3 HI byte YE  ye15 ye14 ye13 ye12 ye11 ye10 ye9 ye8
          @4 LO byte YE  ye7  ye6  ye5  ye4  ye3  ye2  ye1 ye0
          @ -The value of YS [15:0] and YE [15:0] are referred when RAMWR command comes.
          @ -Each value represents one column line in the Frame Memory.
          push {r0-r5,LR}
               @REV16 R2, R0
               @MOV R0, R2
               @REV16 R2, R1
               @MOV R1, R2
               @strh r0, [r5]
               @strh r1, [r5,#2]
               @MOV r0, r5
               @BL DMA_Send
               @BL ReleaseArray
               MOV r3, r1
               MOV r2, r0
               UBFX r0, r2,  #8, #8
               MOV r1, r12
               BL SendData
               UBFX r0, r2, #0, #8
               BL SendData
               UBFX r0, r3, #8, #8
               BL SendData
               UBFX r0, r3, #0, #8
               BL SendData
          pop {r0-r5,LR}
     BX LR

.global ST_RAMWR         @ 0x2C memory write 1...N bytes
@ IN - r0 - array addr
ST_RAMWR:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x2C
          mov r1, #0
          BL SendData
          @====PARAMETERS====
     pop {r0,r1,LR}
     PUSH {LR}
          BL SendData
     POP {LR}
     BX LR
@.DESC      name=ST_RAMWR_CIRC type=proc
@           Circular LCD memory write
@======================================================
@           IN: R0 - data array, R1 - cycles count
@.ENDDESC
.global ST_RAMWR_CIRC
ST_RAMWR_CIRC:
      push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x2C
          mov r1, #0
          BL SendData
          @====PARAMETERS====
     pop {r0,r1,LR}
    PUSH {R0-r5,LR}
          .if (SPI_DMA_USE==1)
               BL SwitchTo16bitTransferMode
               BL DMA_hSendCircular
          .else
               mov r2, r1
               mov r1, #1
RAMWR_Loop:
               BL SendData
               SUBS r2, #1
               BNE RAMWR_Loop
          .endif
     POP {R0-r5,LR}
     BX LR

.global ST_RAMRD         @ 0x2E memory read (read) byte dummy 1...N bytes
ST_RAMRD:
     BX LR

.global ST_PTLAR         @ 0x30 partial start/end address set 2bytes start  + 2bytes end
ST_PTLAR:
     BX LR

.global ST_VSCRDEF         @ 0x33 vertical scrolling definition 6 bytes (3 parts by 2 bytes)
ST_VSCRDEF:
     BX LR

.global ST_TEOFF         @ 0x34 tearing effect line off NO PARAM
ST_TEOFF:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x34
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR
     BX LR

.global ST_TEON         @ 0x35 tearing effect line on 1byte with 1 bit
ST_TEON:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x35
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR
     BX LR

.global ST_MADCTL         @ 0x36 memory data access control 1 byte
@ IN r0 - orientation
ST_MADCTL:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x36
          mov r1, #0
          BL SendData
          @====PARAMETERS===
          @  7   6   5   4   3    2  1  0
          @  my  mx  mv  ml  rgb  mh -  -
          @ D7 - MY -  Page Address Order
          @ D6 - MX - Column Address Order
          @ D5 - MV - Page/Column Order
          @ D4 - ML - Line Address Order
          @ D3 - RGB - RGB/BGR Order
          @ D2 - MH - Display Data Latch Order
          @ Bit D7- Page Address Order
          @    �0� = Top to Bottom (When MADCTL D7=�0�).
          @    �1� = Bottom to Top (When MADCTL D7=�1�).
          @ Bit D6- Column Address Order
          @    �0� = Left to Right (When MADCTL D6=�0�).
          @    �1� = Right to Left (When MADCTL D6=�1�).
          @ Bit D5- Page/Column Order
          @    �0� = Normal Mode (When MADCTL D5=�0�).
          @    �1� = Reverse Mode (When MADCTL D5=�1�)
          @    Note: Bits D7 to D5, alse refer to section 8.12 Address Control
          @Bit D4- Line Address Order
          @    "0� = LCD Refresh Top to Bottom (When MADCTL D4=�0�)
          @    �1� = LCD Refresh Bottom to Top (When MADCTL D4=�1�)
          @ Bit D3- RGB/BGR Order
          @    �0� = RGB (When MADCTL D3=�0�)
          @     �1� = BGR (When MADCTL D3=�1�)
          @ Bit D2- Display Data Latch Data Order
          @    �0� = LCD Refresh Left to Right (When MADCTL D2=�0�)
          @    �1� = LCD Refresh Right to Left (When MADCTL D2=�1�)
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR
     BX LR

.global ST_VSCRSADD         @ 0x37 vertical scrolling start address 2 bytes
ST_VSCRSADD:
     BX LR

.global ST_IDMOFF         @ 0x38 iddle mode off NO PARAM
ST_IDMOFF:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x38
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_IDMON         @ 0x39 iddle mode on NO PARAM
ST_IDMON:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x39
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_COLMOD         @ 0x3A interface pixel format 1byte
@IN r0 - color mode
ST_COLMOD:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0x3A
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @           7 6  5  4  3 2  1  0
     @1 byte XS  0 D6 D5 D4 0 D2 D1 D0
     @ D7 - Set to �0�
     @ D6,D5,D4 - RGB interface color format 101 = 65K of RGB interface
     @                                       110 = 262K of RGB interface
     @ D3 - Set to �0�
     @ D2,D1,D0 - Control interface color format 011 = 12bit/pixel
     @                                           101 = 16bit/pixel
     @                                           110 = 18bit/pixel
     @                                           111 = 16M truncated
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_RAMWRC         @ 0x3C memory write continue 1..N bytes
ST_RAMWRC:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x3C
          mov r1, #0
          BL SendData
          @====PARAMETERS====
     pop {r0,r1,LR}
          BL SendData
     BX LR
.global ST_RAMWRC_COMMAND         @ 0x3C memory write continue 1..N bytes
ST_RAMWRC_COMMAND:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0x3C
          mov r1, #0
          BL SendData
          @====PARAMETERS====
     pop {r0,r1,LR}
     BX LR

.global ST_RAMRDC         @ 0x3E memory read continue  (read) 1byte dummy, 1..N Bytes
ST_RAMRDC:

     BX LR


.global ST_TESCAN         @ 0x44 set tear scanline 2 bytes
ST_TESCAN:
     BX LR

.global ST_RDTESCAN         @ 0x45 read tear scanline 1byte dummy + 2bytes
ST_RDTESCAN:
     BX LR

.global ST_WRDISBV         @ 0x51 write display brightness 1byte
ST_WRDISBV:
     BX LR

.global ST_RDDISBV         @ 0x52 read display brightness 1byte dummy + 1byte
ST_RDDISBV:
     BX LR

.global ST_WRCTRLD         @ 0x53 write CTRL display 1 byte
ST_WRCTRLD:
     BX LR

.global ST_RDCTRLD         @ 0x54 read CTRL display 1 byte dummy + 1 byte
ST_RDCTRLD:
     BX LR

.global ST_WRCACE         @ 0x55 write content adaptive brightness control and color enhancement 1byte
ST_RWCACE:
     BX LR

.global ST_RDCABC         @ 0x56 read content adaptive brightness control 1byte dummy + 1byte
ST_RDCABC:
     BX LR

.global ST_WRCABCMB         @ 0x5E write CABC minimum brightness 1 byte
ST_WRCABCMB:
     BX LR

.global ST_RDCABCMB         @ 0x5F read CABC minimum brightness 1byte dummy + 1 byte
ST_RDCABCMB:
     BX LR

.global ST_RDABCSDR         @ 0x68 read automatic brightness control self-diagnostic result 1byte dummy + 1byte
ST_RDABCSDR:
     BX LR

.global ST_RDID1         @ 0xDA Read ID1 1byte dummy + 1 byte
ST_RDID1:
     BX LR

.global ST_RDID2         @ 0xDB Read ID2 1byte dummy + 1 byte
ST_RDID2:
     BX LR

.global ST_RDID3         @ 0xDC Read ID3 1byte dummy + 1 byte
ST_RDID3:
     BX LR

.GLOBAL ST_PORCTRL
ST_PORCTRL:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, #0xB2
          mov r1, #0
          BL SendData
     pop {r0,r1,LR}
     push {LR}
          @====PARAMETERS====
          @    7    6    5    4    3    2    1   0
          @1   0  BPA6 BPA5 BPA4 BPA3 BPA2 BPA1 BPA0
          @2   0  FPA6 FPA5 FPA4 FPA3 FPA2 FPA1 FPA0
          @3   0    0    0    0    0    0    0  PSEN
          @4 BPB3 BPB2 BPB1 BPB0 FPB3 FPB2 FPB1 FPB0
          @5 BPC3 BPC2 BPC1 BPC0 FPC3 FPC2 FPC1 FPC0
          @ BPA[6:0]: Back porch setting in normal mode. The minimum setting is 0x01.
          @ FPA[6:0]: Front porch setting in normal mode. The minimum setting is 0x01.
          @ PSEN: 0 - DISABLE SEPARATE CONTROL, 1 - ENABLE
          @ BPB[3:0]: Back porch setting in idle mode. The minimum setting is 0x01.
          @ FPB[3:0]: Front porch setting in idle mode. The minimum setting is 0x01.
          @ BPC[3:0]: Back porch setting in partial mode. The minimum setting is 0x01.
          @ FPC[3:0]: Front porch setting in partial mode. The minimum setting is 0x01.
          @ Reset Val: 0x0C, 0x0C, 0x00, 0x33, 0x33
          BL SendData
     pop {LR}
     BX LR

.global ST_GCTRL
ST_GCTRL:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xB7
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @           7   6     5     4   3   2     1     0
     @1 byte XS  0 VGHS2 VGHS1 VGHS0 0 VGLS2 VGLS1 VGLS0
     @  VGHS:         | VGLS:
     @  0x00 | 12.2V  | 0x00 | -7.16V  |
     @  0x01 | 12.54V | 0x01 | -7.67V  |
     @  0x02 | 12.89V | 0x02 | -8.23V  |
     @  0x03 | 13.26V | 0x03 | -8.87V  |
     @  0x04 | 13.65V | 0x04 | -9.60V  |
     @  0x05 | 14.06V | 0x05 | -10.43V  |
     @  0x06 | 14.5V  | 0x06 | -11.38V  |
     @  0x07 | 14.97V | 0x07 | -12.5V  |
     @ Reset: 0x33
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_VCOMS
ST_VCOMS:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xBB
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @           7 6   5     4     3     2     1     0
     @1 byte XS  0 0 VCOM5 VCOM4 VCOM3 VCOM2 VCOM1 VCOM0
     @
     @ Reset: 0x20
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_LCMCTRL
ST_LCMCTRL:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xC0
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @           7  6    5    4   3   2   1   0
     @1 byte XS  0 XMY XBRG XINV XMX XMH XMV XGS
     @ XMY: XOR MY setting in command 36h.
     @ XBGR: XOR RGB setting in command 36h.
     @ XREV: XOR inverse setting in command 21h
     @ XMH: this bit can reverse source output order and only support for RGB interface without RAM mode
     @ XMV: XOR MV setting in command 36h
     @ XMX: XOR MX setting in command 36h.
     @ XGS: XOR GS setting in command E4h.
     @
     @ Reset: 0x2C
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_VDVVRHEN
ST_VDVVRHEN:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xC2
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @           7 6 5 4 3 2 1   0
     @1 byte XS  0 0 0 0 0 0 0 CMDEN
     @2 byte XS  1 1 1 1 1 1 1   1
     @ CMDEN: VDV and VRH command write enable.
     @ CMDEN=�0�: VDV and VRH register value comes from NVM.
     @ CMDEN=�1�, VDV and VRH register value comes from command write.
     @
     @ Reset: 0x01 0xFF
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
          mov r0, #0xFF
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_VRHS
ST_VRHS:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xC3
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @           7  6  5     4     3     2     1     0
     @1 byte XS  0 0 VRHS5 VRHS4 VRHS3 VRHS2 VRHS1 VRHS0
     @
     @ Reset: 0x0B
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_VDVS
ST_VDVS:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xC4
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @           7  6  5     4     3     2     1     0
     @1 byte XS  0 0 VDVS5 VDVS4 VDVS3 VDVS2 VDVS1 VDVS0
     @
     @ Reset: 0x20
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_FRCTRL2
ST_FRCTRL2:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xC6
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @            7    6    5     4     3     2     1     0
     @1 byte XS  NLA2 NLA1 NLA0 RTNA4 RTNA3 RTNA2 RTNA1 RTNA0
     @ NLA[2 :0] : Inversion selection in normal mode.
     @ 0x00 : dot inversion.
     @ 0x07: column inversion.
     @ Reset: 0x0F
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r1, #1
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_PWCTRL1
ST_PWCTRL1:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xD0
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @              7     6     5     4   3 2  1    0
     @ 1 byte XS    1     0     1     0   0 1  0    0
     @ 2 byte XS  AVDD1 AVDD0 AVCL1 AVCL0 0 0 VDS1 VDS0
     @ NLA[2 :0] : Inversion selection in normal mode.
     @ 0x00 : dot inversion.
     @ 0x07: column inversion.
     @ Reset: 0xA4, 0xA1
     pop {r0,r1,LR}
     push {r0,r1,LR}
          mov r2, r0
          mov r0, 0xA4
          mov r1, #1
          BL SendData
          mov r0, r2
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_PVGAMCTRL
ST_PVGAMCTRL:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xE0
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @ 14 bytes
     pop {r0,r1,LR}
     push {r0,r1,LR}
          BL SendData
     pop {r0,r1,LR}
     BX LR

.global ST_NVGAMCTRL
ST_NVGAMCTRL:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, #0xE1
          mov r1, #0
          BL SendData
     @====PARAMETERS====
     @ 14 bytes
     pop {r0,r1,LR}
     push {r0,r1,LR}
          BL SendData
     pop {r0,r1,LR}
     BX LR


