/* @.CHARSET CP1251 */

/* STM32F103xBx, flash 128�� , sram 20�� */

MEMORY
{
     /* FLASH - ����������� flash ������ */
     FLASH      (RX)  : ORIGIN = 0x08000000, LENGTH = 128K

     /* SRAM  - ��� ������ ���������� */
     SRAM       (RW)  : ORIGIN = 0x20000000, LENGTH = 20K

}

PROVIDE(_STACK_END = 0x20005000);    /* ��������� �� ����� ����� */

SECTIONS
{
     .code : {
          . = ALIGN(4);
          *(.vectors);   /* ��������� �������� ���������� */
          *(.text);      /*  */
          *(.asmcode);   /* ����� ��������� */
          *(.rodata);    /* ���������  */
     } > FLASH
     .bss : {
          . = ALIGN(4);
          PROVIDE(_BSS_START = .);
          *(.bss);        /* ���������� � SRAM */
          PROVIDE(_BSS_END = .);
      } > SRAM
}
"FREE_SRAM_START"=.;


