@GNU AS
@.CHARSET =CP1251 ( Cyrillic )

@.DESC     type=module
@ +------------------------------------------------------------------+
@ |       Константы NVIC (Nested vectored interrupt controller)      |
@ |                            CORTEX-M3  Core                       |
@ +------------------------------------------------------------------+
@.ENDDESC

.INCLUDE    "/src/inc/base.inc"

@.ITEM     NVIC_BASE
.EQU  NVIC_ISER0    , 0x00     @  (R/W) Interrupt set-enable registers (NVIC_ISER0)
.EQU  NVIC_ISER1    , 0x04     @  (R/W) Interrupt set-enable registers (NVIC_ISER1)
.EQU  NVIC_ISER2    , 0x08     @  (R/W) Interrupt set-enable registers (NVIC_ISER2)
.EQU  NVIC_ISER3    , 0x0C     @  (R/W) Interrupt set-enable registers (NVIC_ISER2)
.EQU  NVIC_ISER4    , 0x10     @  (R/W) Interrupt set-enable registers (NVIC_ISER2)
.EQU  NVIC_ISER5    , 0x14     @  (R/W) Interrupt set-enable registers (NVIC_ISER2)
.EQU  NVIC_ISER6    , 0x18     @  (R/W) Interrupt set-enable registers (NVIC_ISER2)
.EQU  NVIC_ISER7    , 0x1C     @  (R/W) Interrupt set-enable registers (NVIC_ISER2)
.EQU  NVIC_ICER0    , 0x80     @  (R/W) Interrupt clear-enable registers (NVIC_ICER0)
.EQU  NVIC_ICER1    , 0x84     @  (R/W) Interrupt clear-enable registers (NVIC_ICER1)
.EQU  NVIC_ICER2    , 0x88     @  (R/W) Interrupt clear-enable registers (NVIC_ICER2)
.EQU  NVIC_ICER3    , 0x8C     @  (R/W) Interrupt clear-enable registers (NVIC_ICER2)
.EQU  NVIC_ICER4    , 0x90     @  (R/W) Interrupt clear-enable registers (NVIC_ICER2)
.EQU  NVIC_ICER5    , 0x94     @  (R/W) Interrupt clear-enable registers (NVIC_ICER2)
.EQU  NVIC_ICER6    , 0x98     @  (R/W) Interrupt clear-enable registers (NVIC_ICER2)
.EQU  NVIC_ICER7    , 0x9C     @  (R/W) Interrupt clear-enable registers (NVIC_ICER2)
.EQU  NVIC_ISPR0    , 0x100    @  (R/W) Interrupt set-pending registers (NVIC_ISPR0)
.EQU  NVIC_ISPR1    , 0x104    @  (R/W) Interrupt set-pending registers (NVIC_ISPR1)
.EQU  NVIC_ISPR2    , 0x108    @  (R/W) Interrupt set-pending registers (NVIC_ISPR2)
.EQU  NVIC_ISPR3    , 0x10C    @  (R/W) Interrupt set-pending registers (NVIC_ISPR2)
.EQU  NVIC_ISPR4    , 0x110    @  (R/W) Interrupt set-pending registers (NVIC_ISPR2)
.EQU  NVIC_ISPR5    , 0x114    @  (R/W) Interrupt set-pending registers (NVIC_ISPR2)
.EQU  NVIC_ISPR6    , 0x118    @  (R/W) Interrupt set-pending registers (NVIC_ISPR2)
.EQU  NVIC_ISPR7    , 0x11C    @  (R/W) Interrupt set-pending registers (NVIC_ISPR2)
.EQU  NVIC_ICPR0    , 0x180    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR0)
.EQU  NVIC_ICPR1    , 0x184    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR1)
.EQU  NVIC_ICPR2    , 0x188    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR2)
.EQU  NVIC_ICPR3    , 0x18C    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR2)
.EQU  NVIC_ICPR4    , 0x190    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR2)
.EQU  NVIC_ICPR5    , 0x194    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR2)
.EQU  NVIC_ICPR6    , 0x198    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR2)
.EQU  NVIC_ICPR7    , 0x19C    @  (R/W) Interrupt clear-pending registers (NVIC_ICPR2)
.EQU  NVIC_IABR0    , 0x200    @  (R/W) Interrupt active bit registers (NVIC_IABR0)
.EQU  NVIC_IABR1    , 0x204    @  (R/W) Interrupt active bit registers (NVIC_IABR1)
.EQU  NVIC_IABR2    , 0x208    @  (R/W) Interrupt active bit registers (NVIC_IABR1)
.EQU  NVIC_IABR3    , 0x20C    @  (R/W) Interrupt active bit registers (NVIC_IABR1)
.EQU  NVIC_IABR4    , 0x210    @  (R/W) Interrupt active bit registers (NVIC_IABR1)
.EQU  NVIC_IABR5    , 0x214    @  (R/W) Interrupt active bit registers (NVIC_IABR1)
.EQU  NVIC_IABR6    , 0x218    @  (R/W) Interrupt active bit registers (NVIC_IABR1)
.EQU  NVIC_IABR7    , 0x21C    @  (R/W) Interrupt active bit registers (NVIC_IABR1)
.EQU  NVIC_IP_BASE  , 0x300    @  (R/W) для побайтового доступа к приоритету нужного прерывания
.EQU  NVIC_IPR0     , 0x300    @  (R/W) Interrupt priority registers (NVIC_IPR0)
.EQU  NVIC_IPR1     , 0x304    @  (R/W) Interrupt priority registers (NVIC_IPR1)
.EQU  NVIC_IPR2     , 0x308    @  (R/W) Interrupt priority registers (NVIC_IPR2)
.EQU  NVIC_IPR3     , 0x30C    @  (R/W) Interrupt priority registers (NVIC_IPR3)
.EQU  NVIC_IPR4     , 0x310    @  (R/W) Interrupt priority registers (NVIC_IPR4)
.EQU  NVIC_IPR5     , 0x314    @  (R/W) Interrupt priority registers (NVIC_IPR5)
.EQU  NVIC_IPR6     , 0x318    @  (R/W) Interrupt priority registers (NVIC_IPR6)
.EQU  NVIC_IPR7     , 0x31C    @  (R/W) Interrupt priority registers (NVIC_IPR7)
.EQU  NVIC_IPR8     , 0x320    @  (R/W) Interrupt priority registers (NVIC_IPR8)
.EQU  NVIC_IPR9     , 0x324    @  (R/W) Interrupt priority registers (NVIC_IPR9)
.EQU  NVIC_IPR10    , 0x328    @  (R/W) Interrupt priority registers (NVIC_IPR10)
.EQU  NVIC_IPR11    , 0x32C    @  (R/W) Interrupt priority registers (NVIC_IPR11)
.EQU  NVIC_IPR12    , 0x330    @  (R/W) Interrupt priority registers (NVIC_IPR12)
.EQU  NVIC_IPR13    , 0x334    @  (R/W) Interrupt priority registers (NVIC_IPR13)
.EQU  NVIC_IPR14    , 0x338    @  (R/W) Interrupt priority registers (NVIC_IPR14)
.EQU  NVIC_IPR15    , 0x33C    @  (R/W) Interrupt priority registers (NVIC_IPR15)
.EQU  NVIC_IPR16    , 0x340    @  (R/W) Interrupt priority registers (NVIC_IPR16)
.EQU  NVIC_IPR17    , 0x344    @  (R/W) Interrupt priority registers (NVIC_IPR17)
.EQU  NVIC_IPR18    , 0x348    @  (R/W) Interrupt priority registers (NVIC_IPR18)
.EQU  NVIC_IPR19    , 0x34C    @  (R/W) Interrupt priority registers (NVIC_IPR19)
.EQU  NVIC_IPR20    , 0x350    @  (R/W) Interrupt priority registers (NVIC_IPR20)
.EQU  NVIC_STIR     , 0xE00    @  (W)   Software trigger interrupt register (NVIC_STIR)
@.END

@.ITEM     NVIC_ISER0
.EQU  NVIC_ISER0_INT0, 1 << 0    @  Enable interrupt 0
.EQU  NVIC_ISER0_INT1, 1 << 1    @  Enable interrupt 1
.EQU  NVIC_ISER0_INT2, 1 << 2    @  Enable interrupt 2
.EQU  NVIC_ISER0_INT3, 1 << 3    @  Enable interrupt 3
.EQU  NVIC_ISER0_INT4, 1 << 4    @  Enable interrupt 4
.EQU  NVIC_ISER0_INT5, 1 << 5    @  Enable interrupt 5
.EQU  NVIC_ISER0_INT6, 1 << 6    @  Enable interrupt 6
.EQU  NVIC_ISER0_INT7, 1 << 7    @  Enable interrupt 7
.EQU  NVIC_ISER0_INT8, 1 << 8    @  Enable interrupt 8
.EQU  NVIC_ISER0_INT9, 1 << 9    @  Enable interrupt 9
.EQU  NVIC_ISER0_INT10, 1 << 10    @  Enable interrupt 10
.EQU  NVIC_ISER0_INT11, 1 << 11    @  Enable interrupt 11
.EQU  NVIC_ISER0_INT12, 1 << 12    @  Enable interrupt 12
.EQU  NVIC_ISER0_INT13, 1 << 13    @  Enable interrupt 13
.EQU  NVIC_ISER0_INT14, 1 << 14    @  Enable interrupt 14
.EQU  NVIC_ISER0_INT15, 1 << 15    @  Enable interrupt 15
.EQU  NVIC_ISER0_INT16, 1 << 16    @  Enable interrupt 16
.EQU  NVIC_ISER0_INT17, 1 << 17    @  Enable interrupt 17
.EQU  NVIC_ISER0_INT18, 1 << 18    @  Enable interrupt 18
.EQU  NVIC_ISER0_INT19, 1 << 19    @  Enable interrupt 19
.EQU  NVIC_ISER0_INT20, 1 << 20    @  Enable interrupt 20
.EQU  NVIC_ISER0_INT21, 1 << 21    @  Enable interrupt 21
.EQU  NVIC_ISER0_INT22, 1 << 22    @  Enable interrupt 22
.EQU  NVIC_ISER0_INT23, 1 << 23    @  Enable interrupt 23
.EQU  NVIC_ISER0_INT24, 1 << 24    @  Enable interrupt 24
.EQU  NVIC_ISER0_INT25, 1 << 25    @  Enable interrupt 25
.EQU  NVIC_ISER0_INT26, 1 << 26    @  Enable interrupt 26
.EQU  NVIC_ISER0_INT27, 1 << 27    @  Enable interrupt 27
.EQU  NVIC_ISER0_INT28, 1 << 28    @  Enable interrupt 28
.EQU  NVIC_ISER0_INT29, 1 << 29    @  Enable interrupt 29
.EQU  NVIC_ISER0_INT30, 1 << 30    @  Enable interrupt 30
.EQU  NVIC_ISER0_INT31, 1 << 31    @  Enable interrupt 31
@.END

@.ITEM     NVIC_ISER1
.EQU  NVIC_ISER1_INT32, 1 << 0    @  Enable interrupt 32
.EQU  NVIC_ISER1_INT33, 1 << 1    @  Enable interrupt 33
.EQU  NVIC_ISER1_INT34, 1 << 2    @  Enable interrupt 34
.EQU  NVIC_ISER1_INT35, 1 << 3    @  Enable interrupt 35
.EQU  NVIC_ISER1_INT36, 1 << 4    @  Enable interrupt 36
.EQU  NVIC_ISER1_INT37, 1 << 5    @  Enable interrupt 37
.EQU  NVIC_ISER1_INT38, 1 << 6    @  Enable interrupt 38
.EQU  NVIC_ISER1_INT39, 1 << 7    @  Enable interrupt 39
.EQU  NVIC_ISER1_INT40, 1 << 8    @  Enable interrupt 40
.EQU  NVIC_ISER1_INT41, 1 << 9    @  Enable interrupt 41
.EQU  NVIC_ISER1_INT42, 1 << 10    @  Enable interrupt 42
.EQU  NVIC_ISER1_INT43, 1 << 11    @  Enable interrupt 43
.EQU  NVIC_ISER1_INT44, 1 << 12    @  Enable interrupt 44
.EQU  NVIC_ISER1_INT45, 1 << 13    @  Enable interrupt 45
.EQU  NVIC_ISER1_INT46, 1 << 14    @  Enable interrupt 46
.EQU  NVIC_ISER1_INT47, 1 << 15    @  Enable interrupt 47
.EQU  NVIC_ISER1_INT48, 1 << 16    @  Enable interrupt 48
.EQU  NVIC_ISER1_INT49, 1 << 17    @  Enable interrupt 49
.EQU  NVIC_ISER1_INT50, 1 << 18    @  Enable interrupt 50
.EQU  NVIC_ISER1_INT51, 1 << 19    @  Enable interrupt 51
.EQU  NVIC_ISER1_INT52, 1 << 20    @  Enable interrupt 52
.EQU  NVIC_ISER1_INT53, 1 << 21    @  Enable interrupt 53
.EQU  NVIC_ISER1_INT54, 1 << 22    @  Enable interrupt 54
.EQU  NVIC_ISER1_INT55, 1 << 23    @  Enable interrupt 55
.EQU  NVIC_ISER1_INT56, 1 << 24    @  Enable interrupt 56
.EQU  NVIC_ISER1_INT57, 1 << 25    @  Enable interrupt 57
.EQU  NVIC_ISER1_INT58, 1 << 26    @  Enable interrupt 58
.EQU  NVIC_ISER1_INT59, 1 << 27    @  Enable interrupt 59
.EQU  NVIC_ISER1_INT60, 1 << 28    @  Enable interrupt 60
.EQU  NVIC_ISER1_INT61, 1 << 29    @  Enable interrupt 61
.EQU  NVIC_ISER1_INT62, 1 << 30    @  Enable interrupt 62
.EQU  NVIC_ISER1_INT63, 1 << 31    @  Enable interrupt 63
@.END

@.ITEM     NVIC_ISER2
.EQU  NVIC_ISER2_INT64, 1 << 0    @  Enable interrupt 32
.EQU  NVIC_ISER2_INT65, 1 << 1    @  Enable interrupt 33
.EQU  NVIC_ISER2_INT66, 1 << 2    @  Enable interrupt 34
.EQU  NVIC_ISER2_INT67, 1 << 3    @  Enable interrupt 35
@.END

@.ITEM     NVIC_ICER0
.EQU  NVIC_ICER0_INT0, 1 << 0    @   Disable interrupt 0
.EQU  NVIC_ICER0_INT1, 1 << 1    @   Disable interrupt 1
.EQU  NVIC_ICER0_INT2, 1 << 2    @   Disable interrupt 2
.EQU  NVIC_ICER0_INT3, 1 << 3    @   Disable interrupt 3
.EQU  NVIC_ICER0_INT4, 1 << 4    @   Disable interrupt 4
.EQU  NVIC_ICER0_INT5, 1 << 5    @   Disable interrupt 5
.EQU  NVIC_ICER0_INT6, 1 << 6    @   Disable interrupt 6
.EQU  NVIC_ICER0_INT7, 1 << 7    @   Disable interrupt 7
.EQU  NVIC_ICER0_INT8, 1 << 8    @   Disable interrupt 8
.EQU  NVIC_ICER0_INT9, 1 << 9    @   Disable interrupt 9
.EQU  NVIC_ICER0_INT10, 1 << 10    @   Disable interrupt 10
.EQU  NVIC_ICER0_INT11, 1 << 11    @   Disable interrupt 11
.EQU  NVIC_ICER0_INT12, 1 << 12    @   Disable interrupt 12
.EQU  NVIC_ICER0_INT13, 1 << 13    @   Disable interrupt 13
.EQU  NVIC_ICER0_INT14, 1 << 14    @   Disable interrupt 14
.EQU  NVIC_ICER0_INT15, 1 << 15    @   Disable interrupt 15
.EQU  NVIC_ICER0_INT16, 1 << 16    @   Disable interrupt 16
.EQU  NVIC_ICER0_INT17, 1 << 17    @   Disable interrupt 17
.EQU  NVIC_ICER0_INT18, 1 << 18    @   Disable interrupt 18
.EQU  NVIC_ICER0_INT19, 1 << 19    @   Disable interrupt 19
.EQU  NVIC_ICER0_INT20, 1 << 20    @   Disable interrupt 20
.EQU  NVIC_ICER0_INT21, 1 << 21    @   Disable interrupt 21
.EQU  NVIC_ICER0_INT22, 1 << 22    @   Disable interrupt 22
.EQU  NVIC_ICER0_INT23, 1 << 23    @   Disable interrupt 23
.EQU  NVIC_ICER0_INT24, 1 << 24    @   Disable interrupt 24
.EQU  NVIC_ICER0_INT25, 1 << 25    @   Disable interrupt 25
.EQU  NVIC_ICER0_INT26, 1 << 26    @   Disable interrupt 26
.EQU  NVIC_ICER0_INT27, 1 << 27    @   Disable interrupt 27
.EQU  NVIC_ICER0_INT28, 1 << 28    @   Disable interrupt 28
.EQU  NVIC_ICER0_INT29, 1 << 29    @   Disable interrupt 29
.EQU  NVIC_ICER0_INT30, 1 << 30    @   Disable interrupt 30
.EQU  NVIC_ICER0_INT31, 1 << 31    @   Disable interrupt 31
@.END

@.ITEM     NVIC_ICER1
.EQU  NVIC_ICER1_INT32, 1 << 0    @   Disable interrupt 32
.EQU  NVIC_ICER1_INT33, 1 << 1    @   Disable interrupt 33
.EQU  NVIC_ICER1_INT34, 1 << 2    @   Disable interrupt 34
.EQU  NVIC_ICER1_INT35, 1 << 3    @   Disable interrupt 35
.EQU  NVIC_ICER1_INT36, 1 << 4    @   Disable interrupt 36
.EQU  NVIC_ICER1_INT37, 1 << 5    @   Disable interrupt 37
.EQU  NVIC_ICER1_INT38, 1 << 6    @   Disable interrupt 38
.EQU  NVIC_ICER1_INT39, 1 << 7    @   Disable interrupt 39
.EQU  NVIC_ICER1_INT40, 1 << 8    @   Disable interrupt 40
.EQU  NVIC_ICER1_INT41, 1 << 9    @   Disable interrupt 41
.EQU  NVIC_ICER1_INT42, 1 << 10    @   Disable interrupt 42
.EQU  NVIC_ICER1_INT43, 1 << 11    @   Disable interrupt 43
.EQU  NVIC_ICER1_INT44, 1 << 12    @   Disable interrupt 44
.EQU  NVIC_ICER1_INT45, 1 << 13    @   Disable interrupt 45
.EQU  NVIC_ICER1_INT46, 1 << 14    @   Disable interrupt 46
.EQU  NVIC_ICER1_INT47, 1 << 15    @   Disable interrupt 47
.EQU  NVIC_ICER1_INT48, 1 << 16    @   Disable interrupt 48
.EQU  NVIC_ICER1_INT49, 1 << 17    @   Disable interrupt 49
.EQU  NVIC_ICER1_INT50, 1 << 18    @   Disable interrupt 50
.EQU  NVIC_ICER1_INT51, 1 << 19    @   Disable interrupt 51
.EQU  NVIC_ICER1_INT52, 1 << 20    @   Disable interrupt 52
.EQU  NVIC_ICER1_INT53, 1 << 21    @   Disable interrupt 53
.EQU  NVIC_ICER1_INT54, 1 << 22    @   Disable interrupt 54
.EQU  NVIC_ICER1_INT55, 1 << 23    @   Disable interrupt 55
.EQU  NVIC_ICER1_INT56, 1 << 24    @   Disable interrupt 56
.EQU  NVIC_ICER1_INT57, 1 << 25    @   Disable interrupt 57
.EQU  NVIC_ICER1_INT58, 1 << 26    @   Disable interrupt 58
.EQU  NVIC_ICER1_INT59, 1 << 27    @   Disable interrupt 59
.EQU  NVIC_ICER1_INT60, 1 << 28    @   Disable interrupt 60
.EQU  NVIC_ICER1_INT61, 1 << 29    @   Disable interrupt 61
.EQU  NVIC_ICER1_INT62, 1 << 30    @   Disable interrupt 62
.EQU  NVIC_ICER1_INT63, 1 << 31    @   Disable interrupt 63
@.END

@.ITEM     NVIC_ICER2
.EQU  NVIC_ICER2_INT64, 1 << 0    @   Disable interrupt 32
.EQU  NVIC_ICER2_INT65, 1 << 1    @   Disable interrupt 33
.EQU  NVIC_ICER2_INT66, 1 << 2    @   Disable interrupt 34
.EQU  NVIC_ICER2_INT67, 1 << 3    @   Disable interrupt 35
@.END

@.ITEM     NVIC_ISPR0
.EQU  NVIC_ISPR0_INT0, 1 << 0    @  Changes interrupt state to pending 0
.EQU  NVIC_ISPR0_INT1, 1 << 1    @  Changes interrupt state to pending 1
.EQU  NVIC_ISPR0_INT2, 1 << 2    @  Changes interrupt state to pending 2
.EQU  NVIC_ISPR0_INT3, 1 << 3    @  Changes interrupt state to pending 3
.EQU  NVIC_ISPR0_INT4, 1 << 4    @  Changes interrupt state to pending 4
.EQU  NVIC_ISPR0_INT5, 1 << 5    @  Changes interrupt state to pending 5
.EQU  NVIC_ISPR0_INT6, 1 << 6    @  Changes interrupt state to pending 6
.EQU  NVIC_ISPR0_INT7, 1 << 7    @  Changes interrupt state to pending 7
.EQU  NVIC_ISPR0_INT8, 1 << 8    @  Changes interrupt state to pending 8
.EQU  NVIC_ISPR0_INT9, 1 << 9    @  Changes interrupt state to pending 9
.EQU  NVIC_ISPR0_INT10, 1 << 10    @  Changes interrupt state to pending 10
.EQU  NVIC_ISPR0_INT11, 1 << 11    @  Changes interrupt state to pending 11
.EQU  NVIC_ISPR0_INT12, 1 << 12    @  Changes interrupt state to pending 12
.EQU  NVIC_ISPR0_INT13, 1 << 13    @  Changes interrupt state to pending 13
.EQU  NVIC_ISPR0_INT14, 1 << 14    @  Changes interrupt state to pending 14
.EQU  NVIC_ISPR0_INT15, 1 << 15    @  Changes interrupt state to pending 15
.EQU  NVIC_ISPR0_INT16, 1 << 16    @  Changes interrupt state to pending 16
.EQU  NVIC_ISPR0_INT17, 1 << 17    @  Changes interrupt state to pending 17
.EQU  NVIC_ISPR0_INT18, 1 << 18    @  Changes interrupt state to pending 18
.EQU  NVIC_ISPR0_INT19, 1 << 19    @  Changes interrupt state to pending 19
.EQU  NVIC_ISPR0_INT20, 1 << 20    @  Changes interrupt state to pending 20
.EQU  NVIC_ISPR0_INT21, 1 << 21    @  Changes interrupt state to pending 21
.EQU  NVIC_ISPR0_INT22, 1 << 22    @  Changes interrupt state to pending 22
.EQU  NVIC_ISPR0_INT23, 1 << 23    @  Changes interrupt state to pending 23
.EQU  NVIC_ISPR0_INT24, 1 << 24    @  Changes interrupt state to pending 24
.EQU  NVIC_ISPR0_INT25, 1 << 25    @  Changes interrupt state to pending 25
.EQU  NVIC_ISPR0_INT26, 1 << 26    @  Changes interrupt state to pending 26
.EQU  NVIC_ISPR0_INT27, 1 << 27    @  Changes interrupt state to pending 27
.EQU  NVIC_ISPR0_INT28, 1 << 28    @  Changes interrupt state to pending 28
.EQU  NVIC_ISPR0_INT29, 1 << 29    @  Changes interrupt state to pending 29
.EQU  NVIC_ISPR0_INT30, 1 << 30    @  Changes interrupt state to pending 30
.EQU  NVIC_ISPR0_INT31, 1 << 31    @  Changes interrupt state to pending 31
@.END

@.ITEM     NVIC_ISPR1
.EQU  NVIC_ISPR1_INT32, 1 << 0    @  Changes interrupt state to pending 32
.EQU  NVIC_ISPR1_INT33, 1 << 1    @  Changes interrupt state to pending 33
.EQU  NVIC_ISPR1_INT34, 1 << 2    @  Changes interrupt state to pending 34
.EQU  NVIC_ISPR1_INT35, 1 << 3    @  Changes interrupt state to pending 35
.EQU  NVIC_ISPR1_INT36, 1 << 4    @  Changes interrupt state to pending 36
.EQU  NVIC_ISPR1_INT37, 1 << 5    @  Changes interrupt state to pending 37
.EQU  NVIC_ISPR1_INT38, 1 << 6    @  Changes interrupt state to pending 38
.EQU  NVIC_ISPR1_INT39, 1 << 7    @  Changes interrupt state to pending 39
.EQU  NVIC_ISPR1_INT40, 1 << 8    @  Changes interrupt state to pending 40
.EQU  NVIC_ISPR1_INT41, 1 << 9    @  Changes interrupt state to pending 41
.EQU  NVIC_ISPR1_INT42, 1 << 10    @  Changes interrupt state to pending 42
.EQU  NVIC_ISPR1_INT43, 1 << 11    @  Changes interrupt state to pending 43
.EQU  NVIC_ISPR1_INT44, 1 << 12    @  Changes interrupt state to pending 44
.EQU  NVIC_ISPR1_INT45, 1 << 13    @  Changes interrupt state to pending 45
.EQU  NVIC_ISPR1_INT46, 1 << 14    @  Changes interrupt state to pending 46
.EQU  NVIC_ISPR1_INT47, 1 << 15    @  Changes interrupt state to pending 47
.EQU  NVIC_ISPR1_INT48, 1 << 16    @  Changes interrupt state to pending 48
.EQU  NVIC_ISPR1_INT49, 1 << 17    @  Changes interrupt state to pending 49
.EQU  NVIC_ISPR1_INT50, 1 << 18    @  Changes interrupt state to pending 50
.EQU  NVIC_ISPR1_INT51, 1 << 19    @  Changes interrupt state to pending 51
.EQU  NVIC_ISPR1_INT52, 1 << 20    @  Changes interrupt state to pending 52
.EQU  NVIC_ISPR1_INT53, 1 << 21    @  Changes interrupt state to pending 53
.EQU  NVIC_ISPR1_INT54, 1 << 22    @  Changes interrupt state to pending 54
.EQU  NVIC_ISPR1_INT55, 1 << 23    @  Changes interrupt state to pending 55
.EQU  NVIC_ISPR1_INT56, 1 << 24    @  Changes interrupt state to pending 56
.EQU  NVIC_ISPR1_INT57, 1 << 25    @  Changes interrupt state to pending 57
.EQU  NVIC_ISPR1_INT58, 1 << 26    @  Changes interrupt state to pending 58
.EQU  NVIC_ISPR1_INT59, 1 << 27    @  Changes interrupt state to pending 59
.EQU  NVIC_ISPR1_INT60, 1 << 28    @  Changes interrupt state to pending 60
.EQU  NVIC_ISPR1_INT61, 1 << 29    @  Changes interrupt state to pending 61
.EQU  NVIC_ISPR1_INT62, 1 << 30    @  Changes interrupt state to pending 62
.EQU  NVIC_ISPR1_INT63, 1 << 31    @  Changes interrupt state to pending 63
@.END

@.ITEM     NVIC_ISPR2
.EQU  NVIC_ISPR2_INT64, 1 << 0    @  Changes interrupt state to pending 32
.EQU  NVIC_ISPR2_INT65, 1 << 1    @  Changes interrupt state to pending 33
.EQU  NVIC_ISPR2_INT66, 1 << 2    @  Changes interrupt state to pending 34
.EQU  NVIC_ISPR2_INT67, 1 << 3    @  Changes interrupt state to pending 35
@.END

@.ITEM     NVIC_ICPR0
.EQU  NVIC_ICPR0_INT0, 1 << 0    @   Removes the pending state of an interrupt  0
.EQU  NVIC_ICPR0_INT1, 1 << 1    @   Removes the pending state of an interrupt  1
.EQU  NVIC_ICPR0_INT2, 1 << 2    @   Removes the pending state of an interrupt  2
.EQU  NVIC_ICPR0_INT3, 1 << 3    @   Removes the pending state of an interrupt  3
.EQU  NVIC_ICPR0_INT4, 1 << 4    @   Removes the pending state of an interrupt  4
.EQU  NVIC_ICPR0_INT5, 1 << 5    @   Removes the pending state of an interrupt  5
.EQU  NVIC_ICPR0_INT6, 1 << 6    @   Removes the pending state of an interrupt  6
.EQU  NVIC_ICPR0_INT7, 1 << 7    @   Removes the pending state of an interrupt  7
.EQU  NVIC_ICPR0_INT8, 1 << 8    @   Removes the pending state of an interrupt  8
.EQU  NVIC_ICPR0_INT9, 1 << 9    @   Removes the pending state of an interrupt  9
.EQU  NVIC_ICPR0_INT10, 1 << 10    @   Removes the pending state of an interrupt  10
.EQU  NVIC_ICPR0_INT11, 1 << 11    @   Removes the pending state of an interrupt  11
.EQU  NVIC_ICPR0_INT12, 1 << 12    @   Removes the pending state of an interrupt  12
.EQU  NVIC_ICPR0_INT13, 1 << 13    @   Removes the pending state of an interrupt  13
.EQU  NVIC_ICPR0_INT14, 1 << 14    @   Removes the pending state of an interrupt  14
.EQU  NVIC_ICPR0_INT15, 1 << 15    @   Removes the pending state of an interrupt  15
.EQU  NVIC_ICPR0_INT16, 1 << 16    @   Removes the pending state of an interrupt  16
.EQU  NVIC_ICPR0_INT17, 1 << 17    @   Removes the pending state of an interrupt  17
.EQU  NVIC_ICPR0_INT18, 1 << 18    @   Removes the pending state of an interrupt  18
.EQU  NVIC_ICPR0_INT19, 1 << 19    @   Removes the pending state of an interrupt  19
.EQU  NVIC_ICPR0_INT20, 1 << 20    @   Removes the pending state of an interrupt  20
.EQU  NVIC_ICPR0_INT21, 1 << 21    @   Removes the pending state of an interrupt  21
.EQU  NVIC_ICPR0_INT22, 1 << 22    @   Removes the pending state of an interrupt  22
.EQU  NVIC_ICPR0_INT23, 1 << 23    @   Removes the pending state of an interrupt  23
.EQU  NVIC_ICPR0_INT24, 1 << 24    @   Removes the pending state of an interrupt  24
.EQU  NVIC_ICPR0_INT25, 1 << 25    @   Removes the pending state of an interrupt  25
.EQU  NVIC_ICPR0_INT26, 1 << 26    @   Removes the pending state of an interrupt  26
.EQU  NVIC_ICPR0_INT27, 1 << 27    @   Removes the pending state of an interrupt  27
.EQU  NVIC_ICPR0_INT28, 1 << 28    @   Removes the pending state of an interrupt  28
.EQU  NVIC_ICPR0_INT29, 1 << 29    @   Removes the pending state of an interrupt  29
.EQU  NVIC_ICPR0_INT30, 1 << 30    @   Removes the pending state of an interrupt  30
.EQU  NVIC_ICPR0_INT31, 1 << 31    @   Removes the pending state of an interrupt  31
@.END

@.ITEM     NVIC_ICPR1
.EQU  NVIC_ICPR1_INT32, 1 << 0    @   Removes the pending state of an interrupt  32
.EQU  NVIC_ICPR1_INT33, 1 << 1    @   Removes the pending state of an interrupt  33
.EQU  NVIC_ICPR1_INT34, 1 << 2    @   Removes the pending state of an interrupt  34
.EQU  NVIC_ICPR1_INT35, 1 << 3    @   Removes the pending state of an interrupt  35
.EQU  NVIC_ICPR1_INT36, 1 << 4    @   Removes the pending state of an interrupt  36
.EQU  NVIC_ICPR1_INT37, 1 << 5    @   Removes the pending state of an interrupt  37
.EQU  NVIC_ICPR1_INT38, 1 << 6    @   Removes the pending state of an interrupt  38
.EQU  NVIC_ICPR1_INT39, 1 << 7    @   Removes the pending state of an interrupt  39
.EQU  NVIC_ICPR1_INT40, 1 << 8    @   Removes the pending state of an interrupt  40
.EQU  NVIC_ICPR1_INT41, 1 << 9    @   Removes the pending state of an interrupt  41
.EQU  NVIC_ICPR1_INT42, 1 << 10    @   Removes the pending state of an interrupt  42
.EQU  NVIC_ICPR1_INT43, 1 << 11    @   Removes the pending state of an interrupt  43
.EQU  NVIC_ICPR1_INT44, 1 << 12    @   Removes the pending state of an interrupt  44
.EQU  NVIC_ICPR1_INT45, 1 << 13    @   Removes the pending state of an interrupt  45
.EQU  NVIC_ICPR1_INT46, 1 << 14    @   Removes the pending state of an interrupt  46
.EQU  NVIC_ICPR1_INT47, 1 << 15    @   Removes the pending state of an interrupt  47
.EQU  NVIC_ICPR1_INT48, 1 << 16    @   Removes the pending state of an interrupt  48
.EQU  NVIC_ICPR1_INT49, 1 << 17    @   Removes the pending state of an interrupt  49
.EQU  NVIC_ICPR1_INT50, 1 << 18    @   Removes the pending state of an interrupt  50
.EQU  NVIC_ICPR1_INT51, 1 << 19    @   Removes the pending state of an interrupt  51
.EQU  NVIC_ICPR1_INT52, 1 << 20    @   Removes the pending state of an interrupt  52
.EQU  NVIC_ICPR1_INT53, 1 << 21    @   Removes the pending state of an interrupt  53
.EQU  NVIC_ICPR1_INT54, 1 << 22    @   Removes the pending state of an interrupt  54
.EQU  NVIC_ICPR1_INT55, 1 << 23    @   Removes the pending state of an interrupt  55
.EQU  NVIC_ICPR1_INT56, 1 << 24    @   Removes the pending state of an interrupt  56
.EQU  NVIC_ICPR1_INT57, 1 << 25    @   Removes the pending state of an interrupt  57
.EQU  NVIC_ICPR1_INT58, 1 << 26    @   Removes the pending state of an interrupt  58
.EQU  NVIC_ICPR1_INT59, 1 << 27    @   Removes the pending state of an interrupt  59
.EQU  NVIC_ICPR1_INT60, 1 << 28    @   Removes the pending state of an interrupt  60
.EQU  NVIC_ICPR1_INT61, 1 << 29    @   Removes the pending state of an interrupt  61
.EQU  NVIC_ICPR1_INT62, 1 << 30    @   Removes the pending state of an interrupt  62
.EQU  NVIC_ICPR1_INT63, 1 << 31    @   Removes the pending state of an interrupt  63
@.END

@.ITEM     NVIC_ICPR2
.EQU  NVIC_ICPR2_INT64, 1 << 0    @   Removes the pending state of an interrupt  32
.EQU  NVIC_ICPR2_INT65, 1 << 1    @   Removes the pending state of an interrupt  33
.EQU  NVIC_ICPR2_INT66, 1 << 2    @   Removes the pending state of an interrupt  34
.EQU  NVIC_ICPR2_INT67, 1 << 3    @   Removes the pending state of an interrupt  35
@.END

@.ITEM     NVIC_IABR0
.EQU  NVIC_IABR0_INT0, 1 << 0    @  Active interrupt 0
.EQU  NVIC_IABR0_INT1, 1 << 1    @  Active interrupt 1
.EQU  NVIC_IABR0_INT2, 1 << 2    @  Active interrupt 2
.EQU  NVIC_IABR0_INT3, 1 << 3    @  Active interrupt 3
.EQU  NVIC_IABR0_INT4, 1 << 4    @  Active interrupt 4
.EQU  NVIC_IABR0_INT5, 1 << 5    @  Active interrupt 5
.EQU  NVIC_IABR0_INT6, 1 << 6    @  Active interrupt 6
.EQU  NVIC_IABR0_INT7, 1 << 7    @  Active interrupt 7
.EQU  NVIC_IABR0_INT8, 1 << 8    @  Active interrupt 8
.EQU  NVIC_IABR0_INT9, 1 << 9    @  Active interrupt 9
.EQU  NVIC_IABR0_INT10, 1 << 10    @  Active interrupt 10
.EQU  NVIC_IABR0_INT11, 1 << 11    @  Active interrupt 11
.EQU  NVIC_IABR0_INT12, 1 << 12    @  Active interrupt 12
.EQU  NVIC_IABR0_INT13, 1 << 13    @  Active interrupt 13
.EQU  NVIC_IABR0_INT14, 1 << 14    @  Active interrupt 14
.EQU  NVIC_IABR0_INT15, 1 << 15    @  Active interrupt 15
.EQU  NVIC_IABR0_INT16, 1 << 16    @  Active interrupt 16
.EQU  NVIC_IABR0_INT17, 1 << 17    @  Active interrupt 17
.EQU  NVIC_IABR0_INT18, 1 << 18    @  Active interrupt 18
.EQU  NVIC_IABR0_INT19, 1 << 19    @  Active interrupt 19
.EQU  NVIC_IABR0_INT20, 1 << 20    @  Active interrupt 20
.EQU  NVIC_IABR0_INT21, 1 << 21    @  Active interrupt 21
.EQU  NVIC_IABR0_INT22, 1 << 22    @  Active interrupt 22
.EQU  NVIC_IABR0_INT23, 1 << 23    @  Active interrupt 23
.EQU  NVIC_IABR0_INT24, 1 << 24    @  Active interrupt 24
.EQU  NVIC_IABR0_INT25, 1 << 25    @  Active interrupt 25
.EQU  NVIC_IABR0_INT26, 1 << 26    @  Active interrupt 26
.EQU  NVIC_IABR0_INT27, 1 << 27    @  Active interrupt 27
.EQU  NVIC_IABR0_INT28, 1 << 28    @  Active interrupt 28
.EQU  NVIC_IABR0_INT29, 1 << 29    @  Active interrupt 29
.EQU  NVIC_IABR0_INT30, 1 << 30    @  Active interrupt 30
.EQU  NVIC_IABR0_INT31, 1 << 31    @  Active interrupt 31
@.END

@.ITEM     NVIC_IABR1
.EQU  NVIC_IABR1_INT32, 1 << 0    @  Active interrupt 32
.EQU  NVIC_IABR1_INT33, 1 << 1    @  Active interrupt 33
.EQU  NVIC_IABR1_INT34, 1 << 2    @  Active interrupt 34
.EQU  NVIC_IABR1_INT35, 1 << 3    @  Active interrupt 35
.EQU  NVIC_IABR1_INT36, 1 << 4    @  Active interrupt 36
.EQU  NVIC_IABR1_INT37, 1 << 5    @  Active interrupt 37
.EQU  NVIC_IABR1_INT38, 1 << 6    @  Active interrupt 38
.EQU  NVIC_IABR1_INT39, 1 << 7    @  Active interrupt 39
.EQU  NVIC_IABR1_INT40, 1 << 8    @  Active interrupt 40
.EQU  NVIC_IABR1_INT41, 1 << 9    @  Active interrupt 41
.EQU  NVIC_IABR1_INT42, 1 << 10    @  Active interrupt 42
.EQU  NVIC_IABR1_INT43, 1 << 11    @  Active interrupt 43
.EQU  NVIC_IABR1_INT44, 1 << 12    @  Active interrupt 44
.EQU  NVIC_IABR1_INT45, 1 << 13    @  Active interrupt 45
.EQU  NVIC_IABR1_INT46, 1 << 14    @  Active interrupt 46
.EQU  NVIC_IABR1_INT47, 1 << 15    @  Active interrupt 47
.EQU  NVIC_IABR1_INT48, 1 << 16    @  Active interrupt 48
.EQU  NVIC_IABR1_INT49, 1 << 17    @  Active interrupt 49
.EQU  NVIC_IABR1_INT50, 1 << 18    @  Active interrupt 50
.EQU  NVIC_IABR1_INT51, 1 << 19    @  Active interrupt 51
.EQU  NVIC_IABR1_INT52, 1 << 20    @  Active interrupt 52
.EQU  NVIC_IABR1_INT53, 1 << 21    @  Active interrupt 53
.EQU  NVIC_IABR1_INT54, 1 << 22    @  Active interrupt 54
.EQU  NVIC_IABR1_INT55, 1 << 23    @  Active interrupt 55
.EQU  NVIC_IABR1_INT56, 1 << 24    @  Active interrupt 56
.EQU  NVIC_IABR1_INT57, 1 << 25    @  Active interrupt 57
.EQU  NVIC_IABR1_INT58, 1 << 26    @  Active interrupt 58
.EQU  NVIC_IABR1_INT59, 1 << 27    @  Active interrupt 59
.EQU  NVIC_IABR1_INT60, 1 << 28    @  Active interrupt 60
.EQU  NVIC_IABR1_INT61, 1 << 29    @  Active interrupt 61
.EQU  NVIC_IABR1_INT62, 1 << 30    @  Active interrupt 62
.EQU  NVIC_IABR1_INT63, 1 << 31    @  Active interrupt 63
@.END

@.ITEM     NVIC_IABR2
.EQU  NVIC_IABR2_INT64, 1 << 0    @  Active interrupt 32
.EQU  NVIC_IABR2_INT65, 1 << 1    @  Active interrupt 33
.EQU  NVIC_IABR2_INT66, 1 << 2    @  Active interrupt 34
.EQU  NVIC_IABR2_INT67, 1 << 3    @  Active interrupt 35
@.END


@.ITEM     NVIC_IPR0
.EQU  NVIC_IPR0_IP0_N, 0       @ Interrupt 0 priority field
.EQU  NVIC_IPR0_IP1_N, 8       @ Interrupt 1 priority field
.EQU  NVIC_IPR0_IP2_N, 16      @ Interrupt 2 priority field
.EQU  NVIC_IPR0_IP3_N, 24      @ Interrupt 3 priority field
@.end

@.ITEM     NVIC_IPR1
.EQU  NVIC_IPR1_IP4_N, 0       @ Interrupt 4 priority field
.EQU  NVIC_IPR1_IP5_N, 8       @ Interrupt 5 priority field
.EQU  NVIC_IPR1_IP6_N, 16      @ Interrupt 6 priority field
.EQU  NVIC_IPR1_IP7_N, 24      @ Interrupt 7 priority field
@.end

@.ITEM     NVIC_IPR2
.EQU  NVIC_IPR2_IP8_N, 0       @ Interrupt 8 priority field
.EQU  NVIC_IPR2_IP9_N, 8       @ Interrupt 9 priority field
.EQU  NVIC_IPR2_IP10_N, 16      @ Interrupt 10 priority field
.EQU  NVIC_IPR2_IP11_N, 24      @ Interrupt 11 priority field
@.end

@.ITEM     NVIC_IPR3
.EQU  NVIC_IPR3_IP12_N, 0       @ Interrupt 12 priority field
.EQU  NVIC_IPR3_IP13_N, 8       @ Interrupt 13 priority field
.EQU  NVIC_IPR3_IP14_N, 16      @ Interrupt 14 priority field
.EQU  NVIC_IPR3_IP15_N, 24      @ Interrupt 15 priority field
@.end

@.ITEM     NVIC_IPR4
.EQU  NVIC_IPR4_IP16_N, 0       @ Interrupt 16 priority field
.EQU  NVIC_IPR4_IP17_N, 8       @ Interrupt 17 priority field
.EQU  NVIC_IPR4_IP18_N, 16      @ Interrupt 18 priority field
.EQU  NVIC_IPR4_IP19_N, 24      @ Interrupt 19 priority field
@.end

@.ITEM     NVIC_IPR5
.EQU  NVIC_IPR5_IP20_N, 0       @ Interrupt 20 priority field
.EQU  NVIC_IPR5_IP21_N, 8       @ Interrupt 21 priority field
.EQU  NVIC_IPR5_IP22_N, 16      @ Interrupt 22 priority field
.EQU  NVIC_IPR5_IP23_N, 24      @ Interrupt 23 priority field
@.end

@.ITEM     NVIC_IPR6
.EQU  NVIC_IPR6_IP24_N, 0       @ Interrupt 24 priority field
.EQU  NVIC_IPR6_IP25_N, 8       @ Interrupt 25 priority field
.EQU  NVIC_IPR6_IP26_N, 16      @ Interrupt 26 priority field
.EQU  NVIC_IPR6_IP27_N, 24      @ Interrupt 27 priority field
@.end

@.ITEM     NVIC_IPR7
.EQU  NVIC_IPR7_IP28_N, 0       @ Interrupt 28 priority field
.EQU  NVIC_IPR7_IP29_N, 8       @ Interrupt 29 priority field
.EQU  NVIC_IPR7_IP30_N, 16      @ Interrupt 30 priority field
.EQU  NVIC_IPR7_IP31_N, 24      @ Interrupt 31 priority field
@.end

@.ITEM     NVIC_IPR8
.EQU  NVIC_IPR8_IP32_N, 0       @ Interrupt 32 priority field
.EQU  NVIC_IPR8_IP33_N, 8       @ Interrupt 33 priority field
.EQU  NVIC_IPR8_IP34_N, 16      @ Interrupt 34 priority field
.EQU  NVIC_IPR8_IP35_N, 24      @ Interrupt 35 priority field
@.end

@.ITEM     NVIC_IPR9
.EQU  NVIC_IPR9_IP36_N, 0       @ Interrupt 36 priority field
.EQU  NVIC_IPR9_IP37_N, 8       @ Interrupt 37 priority field
.EQU  NVIC_IPR9_IP38_N, 16      @ Interrupt 38 priority field
.EQU  NVIC_IPR9_IP39_N, 24      @ Interrupt 39 priority field
@.end

@.ITEM     NVIC_IPR10
.EQU  NVIC_IPR10_IP40_N, 0       @ Interrupt 40 priority field
.EQU  NVIC_IPR10_IP41_N, 8       @ Interrupt 41 priority field
.EQU  NVIC_IPR10_IP42_N, 16      @ Interrupt 42 priority field
.EQU  NVIC_IPR10_IP43_N, 24      @ Interrupt 43 priority field
@.end

@.ITEM     NVIC_IPR11
.EQU  NVIC_IPR11_IP44_N, 0       @ Interrupt 44 priority field
.EQU  NVIC_IPR11_IP45_N, 8       @ Interrupt 45 priority field
.EQU  NVIC_IPR11_IP46_N, 16      @ Interrupt 46 priority field
.EQU  NVIC_IPR11_IP47_N, 24      @ Interrupt 47 priority field
@.end

@.ITEM     NVIC_IPR12
.EQU  NVIC_IPR12_IP48_N, 0       @ Interrupt 48 priority field
.EQU  NVIC_IPR12_IP49_N, 8       @ Interrupt 49 priority field
.EQU  NVIC_IPR12_IP50_N, 16      @ Interrupt 50 priority field
.EQU  NVIC_IPR12_IP51_N, 24      @ Interrupt 51 priority field
@.end

@.ITEM     NVIC_IPR13
.EQU  NVIC_IPR13_IP52_N, 0       @ Interrupt 52 priority field
.EQU  NVIC_IPR13_IP53_N, 8       @ Interrupt 53 priority field
.EQU  NVIC_IPR13_IP54_N, 16      @ Interrupt 54 priority field
.EQU  NVIC_IPR13_IP55_N, 24      @ Interrupt 55 priority field
@.end

@.ITEM     NVIC_IPR14
.EQU  NVIC_IPR14_IP56_N, 0       @ Interrupt 56 priority field
.EQU  NVIC_IPR14_IP57_N, 8       @ Interrupt 57 priority field
.EQU  NVIC_IPR14_IP58_N, 16      @ Interrupt 58 priority field
.EQU  NVIC_IPR14_IP59_N, 24      @ Interrupt 59 priority field
@.end

@.ITEM     NVIC_IPR15
.EQU  NVIC_IPR15_IP60_N, 0       @ Interrupt 60 priority field
.EQU  NVIC_IPR15_IP61_N, 8       @ Interrupt 61 priority field
.EQU  NVIC_IPR15_IP62_N, 16      @ Interrupt 62 priority field
.EQU  NVIC_IPR15_IP63_N, 24      @ Interrupt 63 priority field
@.end

@.ITEM     NVIC_IPR16
.EQU  NVIC_IPR16_IP64_N, 0       @ Interrupt 64 priority field
.EQU  NVIC_IPR16_IP65_N, 8       @ Interrupt 65 priority field
.EQU  NVIC_IPR16_IP66_N, 16      @ Interrupt 66 priority field
.EQU  NVIC_IPR16_IP67_N, 24      @ Interrupt 67 priority field
@.end

@.ITEM     NVIC_IPR17
.EQU  NVIC_IPR17_IP68_N, 0       @ Interrupt 68 priority field
.EQU  NVIC_IPR17_IP69_N, 8       @ Interrupt 69 priority field
.EQU  NVIC_IPR17_IP70_N, 16      @ Interrupt 70 priority field
.EQU  NVIC_IPR17_IP71_N, 24      @ Interrupt 71 priority field
@.end

@.ITEM     NVIC_IPR18
.EQU  NVIC_IPR18_IP72_N, 0       @ Interrupt 72 priority field
.EQU  NVIC_IPR18_IP73_N, 8       @ Interrupt 73 priority field
.EQU  NVIC_IPR18_IP74_N, 16      @ Interrupt 74 priority field
.EQU  NVIC_IPR18_IP75_N, 24      @ Interrupt 75 priority field
@.end

@.ITEM     NVIC_IPR19
.EQU  NVIC_IPR19_IP76_N, 0       @ Interrupt 76 priority field
.EQU  NVIC_IPR19_IP77_N, 8       @ Interrupt 77 priority field
.EQU  NVIC_IPR19_IP78_N, 16      @ Interrupt 78 priority field
.EQU  NVIC_IPR19_IP79_N, 24      @ Interrupt 79 priority field
@.end

@.ITEM     NVIC_IPR20
.EQU  NVIC_IPR20_IP80_N, 0       @ Interrupt 80 priority field
@.end

@.ITEM     NVIC_STIR
.equ NVIC_STIR_INTID_M, 0b111111111 @ NTID[8:0] Software generated interrupt ID
@.end


















