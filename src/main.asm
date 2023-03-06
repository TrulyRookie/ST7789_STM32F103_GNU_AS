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
     @MOVW r0, #:lower16:BSS_END_ADDRESS
     @MOVT r0, #:upper16:BSS_END_ADDRESS
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

     BL LCD_Clear

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



