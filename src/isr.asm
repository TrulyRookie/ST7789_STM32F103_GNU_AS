@GNU AS
@.CharSet=CP1251

.SYNTAX    unified                  @ ��������� ��������� ����
.THUMB                              @ ��� ������������ ���������� Thumb
.CPU       cortex-m3                @ ���������

.SECTION   .vectors

@ ������� �������� ����������
     .word     _STACK_END             @ 0x0000 ������� �����
     .word     Start+1                @ 0x0004 RESET


@ ������� ���������� ��� ���� ����������������� STM32F103 Low, Medium, High density devices

     .word     IRQ_NMI+1               @ 0x0008 NMI
     .word     IRQ_HardFault+1         @ 0x000C Hard Fault
     .word     IRQ_MemFault+1          @ 0x0010 Memory management fault
     .word     IRQ_BusFault+1          @ 0x0014 Bus Fault
     .word     IRQ_UsageFault+1        @ 0x0018 Usage Fault
     .word     0               @ 0x001C Reserved
     .word     0               @ 0x0020 Reserved
     .word     0               @ 0x0024 Reserved
     .word     0               @ 0x0028 Reserved
     .word     IRQ_SVCall+1            @ 0x002C SVCall
     .word     IRQ_DebugMonitor+1      @ 0x0030 Debug Monitor
     .word     0                       @ 0x0034
     .word     IRQ_PendSV+1            @ 0x0038 PendSV
     .word     IRQ_SysTick+1           @ 0x003C SysTick

@ ���������� ��������� ����������������
     .word     IRQ_WWDG+1              @ 0x0040 Window Watchdog interrupt
     .word     IRQ_PVD+1               @ 0x0044 PVD through EXTI line detection interrupt
     .word     IRQ_TAMPER+1            @ 0x0048 Tamper interrupts
     .word     IRQ_RTC+1               @ 0x004C RTC global interrupt
     .word     IRQ_FLASH+1             @ 0x0050 Flash global interrupt
     .word     IRQ_RCC+1               @ 0x0054 RCC global interrupt
     .word     IRQ_EXTI0+1             @ 0x0058 EXTI Line0 interrupt
     .word     IRQ_EXTI1+1             @ 0x005C EXTI Line1 interrupt
     .word     IRQ_EXTI2+1             @ 0x0060 EXTI Line2 interrupt
     .word     IRQ_EXTI3+1             @ 0x0064 EXTI Line3 interrupt
     .word     IRQ_EXTI4+1             @ 0x0068 EXTI Line4 interrupt
     .word     IRQ_DMA1_Channel1+1     @ 0x006C DMA1 Channel1 global interrupt
     .word     IRQ_DMA1_Channel2+1     @ 0x0070 DMA1 Channel2 global interrupt
     .word     IRQ_DMA1_Channel3+1     @ 0x0074 DMA1 Channel3 global interrupt
     .word     IRQ_DMA1_Channel4+1     @ 0x0078 DMA1 Channel4 global interrupt
     .word     IRQ_DMA1_Channel5+1     @ 0x007C DMA1 Channel5 global interrupt
     .word     IRQ_DMA1_Channel6+1     @ 0x0080 DMA1 Channel6 global interrupt
     .word     IRQ_DMA1_Channel7+1     @ 0x0084 DMA1 Channel7 global interrupt
     .word     IRQ_ADC1_2+1            @ 0x0088 ADC1 and ADC2 global interrupt
     .word     IRQ_USB_HP_CAN_TX+1     @ 0x008C USB high priority or CAN TX interrupts
     .word     IRQ_USB_LP_CAN_RX0+1    @ 0x0090 USB low priority or CAN RX0 interrupts
     .word     IRQ_CAN_RX1+1           @ 0x0094 CAN RX1 interrupt
     .word     IRQ_CAN_SCE+1           @ 0x0098 CAN SCE interrupt
     .word     IRQ_EXTI9_5+1           @ 0x009C EXTI Line[9:5] interrupts
     .word     IRQ_TIM1_BRK+1          @ 0x00A0 TIM1 Break interrupt
     .word     IRQ_TIM1_UP+1           @ 0x00A4 TIM1 Update interrupt
     .word     IRQ_TIM1_TRG_COM+1      @ 0x00A8 TIM1 Trigger and Commutation interrupts
     .word     IRQ_TIM1_CC+1           @ 0x00AC TIM1 Capture Compare interrupt
     .word     IRQ_TIM2+1              @ 0x00B0 TIM2 global interrupt
     .word     IRQ_TIM3+1              @ 0x00B4 TIM3 global interrupt
     .word     IRQ_TIM4+1              @ 0x00B8 TIM4 global interrupt
     .word     IRQ_I2C1_EV+1           @ 0x00BC I2C1 event interrupt
     .word     IRQ_I2C1_ER+1           @ 0x00C0 I2C1 error interrupt
     .word     IRQ_I2C2_EV+1           @ 0x00C4 I2C2 event interrupt
     .word     IRQ_I2C2_ER+1           @ 0x00C8 I2C2 error interrupt
     .word     IRQ_SPI1+1              @ 0x00CC SPI1 global interrupt
     .word     IRQ_SPI2+1              @ 0x00D0 SPI2 global interrupt
     .word     IRQ_USART1+1            @ 0x00D4 USART1 global interrupt
     .word     IRQ_USART2+1            @ 0x00D8 USART2 global interrupt
     .word     IRQ_USART3+1            @ 0x00DC USART3 global interrupt
     .word     IRQ_EXTI15_10+1         @ 0x00E0 EXTI Line[15:10] interrupts
     .word     IRQ_RTC_Alarm+1         @ 0x00E4 RTC Alarms (A and B) through EXTI line interrupt
     .word     IRQ_USBWakeUp+1         @ 0x00E8 USB On-The-Go FS Wakeup through EXTI line interrupt
     .word     IRQ_TIM8_BRK+1          @ 0x00EC TIM8 Break interrupt
     .word     IRQ_TIM8_UP+1           @ 0x00F0 TIM8 Update interrupt
     .word     IRQ_TIM8_TRG_COM+1      @ 0x00F4 TIM8 Trigger and Commutation interrupts
     .word     IRQ_TIM8_CC+1           @ 0x00F8 TIM8 Capture Compare interrupt
     .word     IRQ_ADC3+1              @ 0x00FC ADC3 global interrupt
     .word     IRQ_FSMC+1              @ 0x0100 FSMC global interrupt
     .word     IRQ_SDIO+1              @ 0x0104 SDIO global interrup
     .word     IRQ_TIM5+1              @ 0x0108 TIM5 global interrupt
     .word     IRQ_SPI3+1              @ 0x010C SPI3 global interrupt
     .word     IRQ_UART4+1             @ 0x0110 UART4 global interrupt
     .word     IRQ_UART5+1             @ 0x0114 UART5 global interrupt
     .word     IRQ_TIM6+1              @ 0x0118 TIM6 global interrupt
     .word     IRQ_TIM7+1              @ 0x011C TIM7 global interrupt
     .word     IRQ_DMA2_Channel1+1     @ 0x0120 DMA2 Channel1 global interrupt
     .word     IRQ_DMA2_Channel2+1     @ 0x0124 DMA2 Channel2 global interrupt
     .word     IRQ_DMA2_Channel3+1     @ 0x0128 DMA2 Channel3 global interrupt
     .word     IRQ_DMA2_Channel4_5+1   @ 0x012C DMA2 Channel4, 5 global interrupt


@ �������� ��� ����� ���������������� ����������

@ ���������� ���� ����������������

.weak IRQ_NMI
IRQ_NMI:

.weak IRQ_HardFault
IRQ_HardFault:

.weak IRQ_MemFault
IRQ_MemFault:

.weak IRQ_BusFault
IRQ_BusFault:

.weak IRQ_UsageFault
IRQ_UsageFault:

.weak IRQ_SVCall
IRQ_SVCall:

.weak IRQ_DebugMonitor
IRQ_DebugMonitor:

.weak IRQ_PendSV
IRQ_PendSV:

.weak IRQ_SysTick
IRQ_SysTick:

@ ���������� ��������� ����������������

.weak     IRQ_WWDG
IRQ_WWDG:

.weak     IRQ_PVD
IRQ_PVD:

.weak     IRQ_TAMPER
IRQ_TAMPER:

.weak     IRQ_RTC
IRQ_RTC:

.weak     IRQ_FLASH
IRQ_FLASH:

.weak     IRQ_RCC
IRQ_RCC:

.weak     IRQ_EXTI0
IRQ_EXTI0:

.weak     IRQ_EXTI1
IRQ_EXTI1:

.weak     IRQ_EXTI2
IRQ_EXTI2:

.weak     IRQ_EXTI3
IRQ_EXTI3:

.weak     IRQ_EXTI4
IRQ_EXTI4:

.weak     IRQ_DMA1_Channel1
IRQ_DMA1_Channel1:

.weak     IRQ_DMA1_Channel2
IRQ_DMA1_Channel2:

.weak     IRQ_DMA1_Channel3
IRQ_DMA1_Channel3:

.weak     IRQ_DMA1_Channel4
IRQ_DMA1_Channel4:

.weak     IRQ_DMA1_Channel5
IRQ_DMA1_Channel5:

.weak     IRQ_DMA1_Channel6
IRQ_DMA1_Channel6:

.weak     IRQ_DMA1_Channel7
IRQ_DMA1_Channel7:

.weak     IRQ_ADC1_2
IRQ_ADC1_2:

.weak     IRQ_USB_HP_CAN_TX
IRQ_USB_HP_CAN_TX:

.weak     IRQ_USB_LP_CAN_RX0
IRQ_USB_LP_CAN_RX0:

.weak     IRQ_CAN_RX1
IRQ_CAN_RX1:

.weak     IRQ_CAN_SCE
IRQ_CAN_SCE:

.weak     IRQ_EXTI9_5
IRQ_EXTI9_5:

.weak     IRQ_TIM1_BRK
IRQ_TIM1_BRK:

.weak     IRQ_TIM1_UP
IRQ_TIM1_UP:

.weak     IRQ_TIM1_TRG_COM
IRQ_TIM1_TRG_COM:

.weak     IRQ_TIM1_CC
IRQ_TIM1_CC:

.weak     IRQ_TIM2
IRQ_TIM2:

.weak     IRQ_TIM3
IRQ_TIM3:

.weak     IRQ_TIM4
IRQ_TIM4:

.weak     IRQ_I2C1_EV
IRQ_I2C1_EV:

.weak     IRQ_I2C1_ER
IRQ_I2C1_ER:

.weak     IRQ_I2C2_EV
IRQ_I2C2_EV:

.weak     IRQ_I2C2_ER
IRQ_I2C2_ER:

.weak     IRQ_SPI1
IRQ_SPI1:

.weak     IRQ_SPI2
IRQ_SPI2:

.weak     IRQ_USART1
IRQ_USART1:

.weak     IRQ_USART2
IRQ_USART2:

.weak     IRQ_USART3
IRQ_USART3:

.weak     IRQ_EXTI15_10
IRQ_EXTI15_10:

.weak     IRQ_RTC_Alarm
IRQ_RTC_Alarm:

.weak     IRQ_USBWakeUp
IRQ_USBWakeUp:

.weak     IRQ_TIM8_BRK
IRQ_TIM8_BRK:

.weak     IRQ_TIM8_UP
IRQ_TIM8_UP:

.weak     IRQ_TIM8_TRG_COM
IRQ_TIM8_TRG_COM:

.weak     IRQ_TIM8_CC
IRQ_TIM8_CC:

.weak     IRQ_ADC3
IRQ_ADC3:

.weak     IRQ_FSMC
IRQ_FSMC:

.weak     IRQ_SDIO
IRQ_SDIO:

.weak     IRQ_TIM5
IRQ_TIM5:

.weak     IRQ_SPI3
IRQ_SPI3:

.weak     IRQ_UART4
IRQ_UART4:

.weak     IRQ_UART5
IRQ_UART5:

.weak     IRQ_TIM6
IRQ_TIM6:

.weak     IRQ_TIM7
IRQ_TIM7:

.weak     IRQ_DMA2_Channel1
IRQ_DMA2_Channel1:

.weak     IRQ_DMA2_Channel2
IRQ_DMA2_Channel2:

.weak     IRQ_DMA2_Channel3
IRQ_DMA2_Channel3:

.weak     IRQ_DMA2_Channel4_5
IRQ_DMA2_Channel4_5:

int_vect_terminator:
          B     int_vect_terminator
