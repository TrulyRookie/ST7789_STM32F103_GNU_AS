
@.CharSet=CP1251
@GNU AS

.syntax unified     @ синтаксис исходного кода
.thumb              @ тип используемых инструкций Thumb
.cpu cortex-m3      @ процессор

.INCLUDE "SRC/INC/UTILS.INC"

@.global FREE_RAM
@.global TOTAL_FREE_RAM_MEMORY

.section .bss
     .align (2)
     TOTAL_FREE_RAM_MEMORY: .word 0x0
     FREE_RAM:.word 0X0
     @BLOCKS_ARRAY:.word 0x0
.section .asmcode
     .word FREE_SRAM_START

.global GetFreeMemAmount
GetFreeMemAmount:    @out - free memory amount stores in TOTAL_FREE_RAM_MEMORY
     PUSH {r0,r1, LR}
     LDR r0, =FREE_SRAM_START @MOVD r0, FREE_SRAM_START           @first free SRAM address to r0    @r0 = {FREE_SRAM_START = free_memory_address}
     LDR r1, =FREE_RAM        @MOVD R1, FREE_RAM                  @POINTER TO FREE MEMORY           @r1 = {FREE_RAM* = null}
     STR R0, [R1]                       @ FREE_RAM = FREE_SRAM_START {FREE_RAM* = free_memory_address}
     MOV R1, SP                         @ r1 = STACK_TOP_ADDR
     ADD R1, #200                       @ buffer for 50 stack writes
     RSB r0, R1                         @ r0 = STACK_TOP - free_memory_address (total free memory amout in bytes)
     LDR r1, =TOTAL_FREE_RAM_MEMORY     @MOVD r1, TOTAL_FREE_RAM_MEMORY     @ r0 = TOTAL_FREE_RAM_MEMORY {TOTAL_FREE_RAM_MEMORY* = mem_size}
     STR r0, [r1]                       @ TOTAL_FREE_RAM_MEMORY* = new_mem_size
     POP {R0,r1, LR}
     BX LR
@.DESC     name=GetArray type=proc
@ ***************************************************************************
@ *                  Выделение памяти под массив                            *
@ ***************************************************************************
@ | Задание области экрана для операций                                     |
@ | Параметры:                                                              |
@ | Входные:
@ |  R0 - размер массива                                                    |
@ |  R1 - размер данных 0, 1, 2 степени двойки                              |
@ | Результат:
@ |  R5 - адрес массива
@ +-------------------------------------------------------------------------+
@.ENDDESC
.global GetArray
@IN - r0, size of array, bytes, r1 - align 0 - byte, 1 - halfword, 2 - word
@OUT - r5, array address
GetArray:
     push {r0-r4,lr}
          MVN r5, #1
          ADD r5, #1                      @ r5 = 0xFFFFFFFF
          LSL R4, r0, r1                  @ byte_array_size{r4} = size * data_size
          LSL R2, R1, #16                 @ data size in hi hword
          ORR R0, R0, R2                  @ merge data size with array size
          ADD r4, #4                      @ byte_array_size += 4 - word buffer for size storing
          BL GetFreeMemAmount             @ check valid free memory
          LDR r1, =TOTAL_FREE_RAM_MEMORY  @r1 = pTOTAL_FREE_RAM_MEMORY  - pointer to free menmory amount
          LDR r1, [r1]                    @r1 = *pTOTAL_FREE_RAM_MEMORY
          cmp r1, r4                      @ if (*TOTAL_FREE_RAM_MEMORY < array_size)
          bmi GetArray_exit               @ then return -1
          LDR r3, =FREE_RAM               @ r3 = ppFREE_RAM
          LDR r5, [r3]                    @ array{r5} = *ppFREE_RAM
          ADD r2, r5, r4                  @ r2 = *ppFREE_RAM{r5} + array_size
          STR r2, [r3]                    @ *ppFREE_RAM{[r3]} = r2
          str r0, [r5]                    @ *array{[r5]} = array_size
          add r5, #4                      @ array += 4 (shift addr by word)
GetArray_exit:                            @ return array{r5}
     pop {r0-r4,lr}
     BX LR
.global ReleaseArray
@ IN: r0 - pointer to array
ReleaseArray:                    @ ReleaseArray(*array)
     push {r0-r4,LR}
          SUB r0, #4             @ array{r0} -= 4 -> *array{[r0]} == array_size - array start address
          LDR r2, =FREE_RAM      @ r2 = ppFREE_RAM
          str r0, [r2]           @ *ppFREE_RAM{[r2]} = r3
     pop {r0-r4,LR}              @ return
     BX LR

@.DESC     name=GetFilledArray type=proc
@ ***************************************************************************
@ *                  Выделение памяти под массив                            *
@ ***************************************************************************
@ | Задание области экрана для операций                                     |
@ | Параметры:                                                              |
@ | Входные:                                                                |
@ |  R0 - размер массива                                                    |
@ |  R1 - размер данных 0, 1, 2 степени двойки                                     |
@ |  R2 - данные                                                            |
@ | Результат:                                                              |
@ |  R5 - адрес массива                                                     |
@ +-------------------------------------------------------------------------+
@.ENDDESC
.global GetFilledArray
GetFilledArray:
     PUSH {r0-r4,LR}
          BL GetArray         @ make array R0 size of R1 data size
          MOV r3, #0          @ cycle counter
GetFilledArray_Fill_Loop:
          LSL r4, r3, r1
          CMP r1, #0
          BEQ GFA_BYTE
          CMP r1, #1
          BEQ GFA_HALF_WORD
          CMP r1, #2
          BEQ GFA_WORD
GFA_BYTE:
          STRB r2, [r5,r4]
          B GFA_Exit
GFA_HALF_WORD:
          STRH r2, [r5,r4]
          B GFA_Exit
GFA_WORD:
          STR r2, [r5,r4]
GFA_Exit:
          ADD r3, #1
          CMP r3, r0
          BNE GetFilledArray_Fill_Loop
     POP {r0-r4,LR}
     BX LR


