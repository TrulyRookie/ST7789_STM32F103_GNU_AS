@GNU AS
@.CharSet=CP1251 (Cyrillic)

@.desc type=module
@ +-----------------------------------------------------------+
@ |       Определения DWT (Data Watchpoint and Trace)         |
@ |                       CORTEX-M3 Core                      |
@ +-----------------------------------------------------------+
@.enddesc

.INCLUDE    "/src/inc/base.inc"

@.item DWT_BASE
.equ DWT_CTRL      , 0x000 @ (R/W)  Control Register
.equ DWT_CYCCNT    , 0x004 @ (R/W)  Cycle Count Register
.equ DWT_CPICNT    , 0x008 @ (R/W)  CPI Count Register
.equ DWT_EXCCNT    , 0x00C @ (R/W)  Exception Overhead Count Register
.equ DWT_SLEEPCNT  , 0x010 @ (R/W)  Sleep Count Register
.equ DWT_LSUCNT    , 0x014 @ (R/W)  LSU Count Register
.equ DWT_FOLDCNT   , 0x018 @ (R/W)  Folded-instruction Count Register
.equ DWT_PCSR      , 0x01C @ (R)  Program Counter Sample Register
.equ DWT_COMP0     , 0x020 @ (R/W)  Comparator Register 0
.equ DWT_MASK0     , 0x024 @ (R/W)  Mask Register 0
.equ DWT_FUNCTION0 , 0x028 @ (R/W)  Function Register 0
.equ DWT_COMP1     , 0x030 @ (R/W)  Comparator Register 1
.equ DWT_MASK1     , 0x034 @ (R/W)  Mask Register 1
.equ DWT_FUNCTION1 , 0x038 @ (R/W)  Function Register 1
.equ DWT_COMP2     , 0x040 @ (R/W)  Comparator Register 2
.equ DWT_MASK2     , 0x044 @ (R/W)  Mask Register 2
.equ DWT_FUNCTION2 , 0x048 @ (R/W)  Function Register 2
.equ DWT_COMP3     , 0x050 @ (R/W)  Comparator Register 3
.equ DWT_MASK3     , 0x054 @ (R/W)  Mask Register 3
.equ DWT_FUNCTION3 , 0x058 @ (R/W)  Function Register 3
@.end





@.item DWT_CTRL
.equ DWT_CTRL_NUMCOMP_N       , 28
.equ DWT_CTRL_NUMCOMP         , 0xF << DWT_CTRL_NUMCOMP_N
.equ DWT_CTRL_NOTRCPKT_N      , 27
.equ DWT_CTRL_NOTRCPKT        , 1 << DWT_CTRL_NOTRCPKT_N
.equ DWT_CTRL_NOEXTTRIG_N     , 26
.equ DWT_CTRL_NOEXTTRIG       , 1 << DWT_CTRL_NOEXTTRIG_N
.equ DWT_CTRL_NOCYCCNT_N      , 25
.equ DWT_CTRL_NOCYCCNT        , 1 << DWT_CTRL_NOCYCCNT_N
.equ DWT_CTRL_NOPRFCNT_N      , 24
.equ DWT_CTRL_NOPRFCNT        , 1 << DWT_CTRL_NOPRFCNT_N
.equ DWT_CTRL_CYCEVTENA_N     , 22
.equ DWT_CTRL_CYCEVTENA       , 1 << DWT_CTRL_CYCEVTENA_N
.equ DWT_CTRL_FOLDEVTENA_N    , 21
.equ DWT_CTRL_FOLDEVTENA      , 1 << DWT_CTRL_FOLDEVTENA_N
.equ DWT_CTRL_LSUEVTENA_N     , 20
.equ DWT_CTRL_LSUEVTENA       , 1 << DWT_CTRL_LSUEVTENA_N
.equ DWT_CTRL_SLEEPEVTENA_N   , 19
.equ DWT_CTRL_SLEEPEVTENA     , 1 << DWT_CTRL_SLEEPEVTENA_N
.equ DWT_CTRL_EXCEVTENA_N     , 18
.equ DWT_CTRL_EXCEVTENA       , 1 << DWT_CTRL_EXCEVTENA_N
.equ DWT_CTRL_CPIEVTENA_N     , 17
.equ DWT_CTRL_CPIEVTENA       , 1 << DWT_CTRL_CPIEVTENA_N
.equ DWT_CTRL_EXCTRCENA_N     , 16
.equ DWT_CTRL_EXCTRCENA       , 1 << DWT_CTRL_EXCTRCENA_N
.equ DWT_CTRL_PCSAMPLENA_N    , 12
.equ DWT_CTRL_PCSAMPLENA      , 1 << DWT_CTRL_PCSAMPLENA_N
.equ DWT_CTRL_SYNCTAP_N       , 10
.equ DWT_CTRL_SYNCTAP         , 3 << DWT_CTRL_SYNCTAP_N
.equ DWT_CTRL_CYCTAP_N        , 9
.equ DWT_CTRL_CYCTAP          , 1 << DWT_CTRL_CYCTAP_N
.equ DWT_CTRL_POSTINIT_N      , 5
.equ DWT_CTRL_POSTINIT        , 0xF << DWT_CTRL_POSTINIT_N
.equ DWT_CTRL_POSTPRESET_N    , 1
.equ DWT_CTRL_POSTPRESET      , 0xF << DWT_CTRL_POSTPRESET_N
.equ DWT_CTRL_CYCCNTENA_N     , 0
.equ DWT_CTRL_CYCCNTENA       , 1 << DWT_CTRL_CYCCNTENA_N
@.end


@.item DWT_CPICNT
.equ DWT_CPICNT_CPICNT_N      , 0
.equ DWT_CPICNT_CPICNT        , 0xFF << DWT_CPICNT_CPICNT_N
@.end

@.item DWT_EXCCNT
.equ DWT_EXCCNT_EXCCNT_N      , 0
.equ DWT_EXCCNT_EXCCNT        , 0xFF << DWT_EXCCNT_EXCCNT_N
@.end

@.item DWT_SLEEPCNT
.equ DWT_SLEEPCNT_SLEEPCNT_N  , 0
.equ DWT_SLEEPCNT_SLEEPCNT    , 0xFF << DWT_SLEEPCNT_SLEEPCNT_N
@.end

@.item DWT_LSUCNT
.equ DWT_LSUCNT_LSUCNT_N      , 0
.equ DWT_LSUCNT_LSUCNT        , 0xFF << DWT_LSUCNT_LSUCNT_N
@.end

@.item DWT_FOLDCNT
.equ DWT_FOLDCNT_FOLDCNT_N    , 0
.equ DWT_FOLDCNT_FOLDCNT      , 0xFF << DWT_FOLDCNT_FOLDCNT_N
@.end

@.item DWT_MASK0  DWT_MASK1  DWT_MASK2  DWT_MASK3
.equ DWT_MASK_MASK_N          , 0
.equ DWT_MASK_MASK            , 0x1F << DWT_MASK_MASK_N
@.end

@.item DWT_FUNCTION0   DWT_FUNCTION1    DWT_FUNCTION2   DWT_FUNCTION3
.equ DWT_FUNCTION_MATCHED_N   , 24
.equ DWT_FUNCTION_MATCHED     , 1 << DWT_FUNCTION_MATCHED_N
.equ DWT_FUNCTION_DATAVADDR1_N, 16
.equ DWT_FUNCTION_DATAVADDR1  , 0xF << DWT_FUNCTION_DATAVADDR1_N
.equ DWT_FUNCTION_DATAVADDR0_N, 12
.equ DWT_FUNCTION_DATAVADDR0  , 0xF << DWT_FUNCTION_DATAVADDR0_N
.equ DWT_FUNCTION_DATAVSIZE_N , 10
.equ DWT_FUNCTION_DATAVSIZE   , 3 << DWT_FUNCTION_DATAVSIZE_N
.equ DWT_FUNCTION_LNK1ENA_N   , 9
.equ DWT_FUNCTION_LNK1ENA     , 1 << DWT_FUNCTION_LNK1ENA_N
.equ DWT_FUNCTION_DATAVMATCH_N, 8
.equ DWT_FUNCTION_DATAVMATCH  , 1 << DWT_FUNCTION_DATAVMATCH_N
.equ DWT_FUNCTION_CYCMATCH_N  , 7
.equ DWT_FUNCTION_CYCMATCH    , 1 << DWT_FUNCTION_CYCMATCH_N
.equ DWT_FUNCTION_EMITRANGE_N , 5
.equ DWT_FUNCTION_EMITRANGE   , 1 << DWT_FUNCTION_EMITRANGE_N
.equ DWT_FUNCTION_FUNCTION_N  , 0
.equ DWT_FUNCTION_FUNCTION    , 0xF << DWT_FUNCTION_FUNCTION_N
@.end




