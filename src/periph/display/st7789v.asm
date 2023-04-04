@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор

.include "/src/inc/st7789v.inc"
.include "/src/inc/spi.inc"
.include "/src/inc/utils.inc"

.section .asmcode



@ SendData:  @ IN r0 - data byte, r1: 0 - command, 1 - data
.global ST_NOP          @ 0x00 operation  NO PARAM
ST_NOP:
     push {r0,LR}
          mov r0, OP_NOP
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_SWRESET      @ 0x01 software reset  NO PARAM
ST_SWRESET:
     push {r0,LR}
          mov r0, OP_SWRESET
          BL SendCommand
     pop {r0,LR}
     BX LR
/*
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
*/
.global ST_SLPIN         @ 0x10 sleep in NO PARAM
ST_SLPIN:
     push {r0,LR}
          mov r0, OP_SLPIN
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_SLPOUT         @ 0x11 sleep out NO PARAM
ST_SLPOUT:
     push {r0,LR}
          mov r0, OP_SLPOUT
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_PTLON         @ 0x12 partial mode on NO PARAM
ST_PTLON:
     push {r0,LR}
          mov r0, OP_PTLON
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_NORON         @ 0x13 partial off (normal) NO PARAM
ST_NORON:
     push {r0,LR}
          mov r0, OP_NORON
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_INVOFF         @ 0x20 display inversion off NO PARAM
ST_INVOFF:
     push {r0,LR}
          mov r0, OP_INVOFF
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_INVON         @ 0x21 display inversion on NO PARAM
ST_INVON:
     push {r0,LR}
          mov r0, OP_INVON
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_GAMSET
@ 0x26 set gamma. IN: r1 - number of curve 1-4
ST_GAMSET:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, OP_GAMSET
          BL SendCommand
          @====PARAMETERS====
          @ 7  6  5  4  3   2   1   0
          @ 0  0  0  0 CG3 GC2 GC1 GC0
          @ 01h - GC0 Gamma Curve 1 (G2.2)
          @ 02h - GC1 Gamma Curve 2 (G1.8)
          @ 04h - GC2 Gamma Curve 3 (G2.5)
          @ 08h - GC3 Gamma Curve 4 (G1.0)
          @ r0 - curve number
          MOV r0, r1
          SUB r0, r12
          LSR r0, r12, r0
          BL SendParameter
     pop {r0,r1,LR}
     BX LR

.global ST_DISPOFF        @ 0x28 display off NO PARAM
ST_DISPOFF:
     push {r0,LR}
          @====COMMAND=====
          mov r0, OP_DISPOFF
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_DISPON         @ 0x29 display on NO PARAM
ST_DISPON:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, OP_DISPON
          BL SendCommand
     pop {r0,r1,LR}
     BX LR

@.DESC     name=ST_CASET type=proc
@ ***************************************************************************
@ *                  ”становка адресов столбцов                             *
@ ***************************************************************************
@ | ѕараметры:                                                              |
@ |  R1 - координаты XE: 15:0                                               |
@ |  R1 - координаты XS: 31:16                                               |
@ +-------------------------------------------------------------------------+
@.ENDDESC
.global ST_CASET
@ 0x2A column address set
ST_CASET:
     PUSH {r0-r1,LR}
@///// COMMAND \\\\\\\
     MOV R0, OP_CASET
     BL SendCommand
@///// PARAMETERS \\\\\\
     MOV R0, R1
     BL Send4BParameters
     pop {r0-r1,LR}
     BX LR

@.DESC     name=ST_RASET type=proc
@ ***************************************************************************
@ *                  ”становка адресов столбцов                             *
@ ***************************************************************************
@ | ѕараметры:                                                              |
@ |  R1 - координаты YS: 15:0                                               |
@ |  R1 - координаты YE: 15:0                                               |
@ +-------------------------------------------------------------------------+
.global ST_RASET
@ 0x2A column address set r0 - XS (start) , r1 - XE (end)
ST_RASET:
     PUSH {r0-r1,LR}
@///// COMMAND \\\\\\\
     MOV R0, OP_RASET
     BL SendCommand
@///// PARAMETERS \\\\\\
     MOV R0, R1
     BL Send4BParameters
     pop {r0-r1,LR}
     BX LR

.global ST_RAMWR
ST_RAMWR:
     PUSH {r0,lr}
     MOV R0, OP_RAMWR
     BL SendCommand
     POP {R0,LR}
     BX LR
/*
.global ST_RAMRD         @ 0x2E memory read (read) byte dummy 1...N bytes
ST_RAMRD:
     BX LR

.global ST_PTLAR         @ 0x30 partial start/end address set 2bytes start  + 2bytes end
ST_PTLAR:
     BX LR

.global ST_VSCRDEF         @ 0x33 vertical scrolling definition 6 bytes (3 parts by 2 bytes)
ST_VSCRDEF:
     BX LR
*/
.global ST_TEOFF         @ 0x34 tearing effect line off NO PARAM
ST_TEOFF:
     push {r0,LR}
          @====COMMAND=====
          mov r0, OP_TEOFF
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_TEON         @ 0x35 tearing effect line on 1byte with 1 bit
ST_TEON:
     push {r0,LR}
          @====COMMAND=====
          mov r0, OP_TEON
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_MADCTL         @ 0x36 memory data access control 1 byte
@ IN r1 - orientation
ST_MADCTL:
     push {r0,r1,LR}
          @====COMMAND=====
          mov r0, OP_MADCTL
          BL SendCommand
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
          @    У0Ф = Top to Bottom (When MADCTL D7=Ф0Ф).
          @    У1Ф = Bottom to Top (When MADCTL D7=Ф1Ф).
          @ Bit D6- Column Address Order
          @    У0Ф = Left to Right (When MADCTL D6=Ф0Ф).
          @    У1Ф = Right to Left (When MADCTL D6=Ф1Ф).
          @ Bit D5- Page/Column Order
          @    У0Ф = Normal Mode (When MADCTL D5=Ф0Ф).
          @    У1Ф = Reverse Mode (When MADCTL D5=Ф1Ф)
          @    Note: Bits D7 to D5, alse refer to section 8.12 Address Control
          @Bit D4- Line Address Order
          @    "0Ф = LCD Refresh Top to Bottom (When MADCTL D4=Ф0Ф)
          @    У1Ф = LCD Refresh Bottom to Top (When MADCTL D4=Ф1Ф)
          @ Bit D3- RGB/BGR Order
          @    У0Ф = RGB (When MADCTL D3=Ф0Ф)
          @     У1Ф = BGR (When MADCTL D3=Ф1Ф)
          @ Bit D2- Display Data Latch Data Order
          @    У0Ф = LCD Refresh Left to Right (When MADCTL D2=Ф0Ф)
          @    У1Ф = LCD Refresh Right to Left (When MADCTL D2=Ф1Ф)
          mov r0, r1
          BL SendParameter
     pop {r0,r1,LR}
     BX LR

.global ST_VSCRSADD         @ 0x37 vertical scrolling start address 2 bytes
ST_VSCRSADD:
     BX LR

.global ST_IDMOFF         @ 0x38 iddle mode off NO PARAM
ST_IDMOFF:
     push {r0,LR}
          @====COMMAND=====
          mov r0, OP_IDMOFF
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_IDMON         @ 0x39 iddle mode on NO PARAM
ST_IDMON:
     push {r0,LR}
          @====COMMAND=====
          mov r0, OP_IDMON
          BL SendCommand
     pop {r0,LR}
     BX LR

.global ST_COLMOD         @ 0x3A interface pixel format 1byte
@IN r1 - color mode
ST_COLMOD:
     push {r0,r1,LR}
     @====COMMAND=====
          mov r0, OP_COLMOD
          BL SendCommand
     @====PARAMETERS====
     @           7 6  5  4  3 2  1  0
     @1 byte XS  0 D6 D5 D4 0 D2 D1 D0
     @ D7 - Set to С0Т
     @ D6,D5,D4 - RGB interface color format 101 = 65K of RGB interface
     @                                       110 = 262K of RGB interface
     @ D3 - Set to С0Т
     @ D2,D1,D0 - Control interface color format 011 = 12bit/pixel
     @                                           101 = 16bit/pixel
     @                                           110 = 18bit/pixel
     @                                           111 = 16M truncated
          mov r0, r1
          BL SendParameter
     pop {r0,r1,LR}
     BX LR

.global ST_RAMWRC         @ 0x3C memory write continue 1..N bytes
ST_RAMWRC:
     push {r0,LR}
          @====COMMAND=====
          mov r0, OP_RAMWRC
          BL SendCommand
          @====PARAMETERS====
     pop {r0,LR}
     BX LR
/*
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
     @ CMDEN=Ф0Ф: VDV and VRH register value comes from NVM.
     @ CMDEN=Ф1Ф, VDV and VRH register value comes from command write.
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

*/
