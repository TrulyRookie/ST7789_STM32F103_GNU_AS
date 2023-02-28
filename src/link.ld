/* @.CHARSET CP1251 */

/* STM32F103xBx, flash 128кб , sram 20кб */

MEMORY
{
     /* FLASH - Программная flash память */
     FLASH      (RX)  : ORIGIN = 0x08000000, LENGTH = 128K

     /* SRAM  - ОЗУ общего назначения */
     SRAM       (RW)  : ORIGIN = 0x20000000, LENGTH = 20K

}

PROVIDE(_STACK_END = 0x20005000);    /* указатель на конец стека */

SECTIONS
{
     .code : {
          . = ALIGN(4);
          *(.vectors);   /* Указатели векторов прерываний */
          *(.text);      /*  */
          *(.asmcode);   /* Текст программы */
          *(.rodata);    /* Константы  */
     } > FLASH
     .bss : {
          . = ALIGN(4);
          PROVIDE(_BSS_START = .);
          *(.bss);        /* Переменные в SRAM */
          PROVIDE(_BSS_END = .);
      } > SRAM
}
"FREE_SRAM_START"=.;


