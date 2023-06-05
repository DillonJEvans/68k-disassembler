*------------------------------------------------------------------------------
* Title      : ParseMisc
* Written by : Dillon Evans
* Date       : 6/5/23
* Description: Parses and displays the following instructions:
*              JSR, LEA, NOP, RTS
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseJsr
* Description: Determines if an instruction word is a JSR instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a JSR, 0 otherwise.
*------------------------------------------------------------------------------
ParseJsr
    BSR     IsJsr
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayJsr

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsJsr
* Description: Determines if an instruction word is a JSR instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a JSR, 0 otherwise.
*------------------------------------------------------------------------------
IsJsr
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$FFC0,D2   * Isolate the first 10 bits
    CMPI.W  #$4E80,D2   * If the first 10 bits are not 4E8:
    BNE     .Return     *   The instruction is not JSR

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayJsr
* Description: Displays a JSR instruction word.
* Parameters : D1.W = The JSR instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayJsr

.Registers  REG     D0-D3/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D3, and A1

    LEA     Jsr,A1
    BSR     DisplayInstName     * Display the instruction name

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address

    MOVE.L  D0,D1
    MOVE.B  #%01100100,D3
    BSR     DisplayEA           * Display the effective address

    MOVE.B  D0,D1
    CLR.B   D2
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    MOVEM.L (SP)+,.Registers    * Restore D0 to D3, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseLea
* Description: Determines if an instruction word is a LEA instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a LEA, 0 otherwise.
*------------------------------------------------------------------------------
ParseLea
    BSR     IsLea
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayLea

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsLea
* Description: Determines if an instruction word is a LEA instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a LEA, 0 otherwise.
*------------------------------------------------------------------------------
IsLea
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$4000,D2   * If the opcode is not 0100 (4):
    BNE     .Return     *   The instruction is not LEA

    MOVE.W  D1,D2
    ANDI.W  #$01C0,D2   * Isolate bits 8, 7, and 6
    CMPI.W  #$01C0,D2   * If the bits are not 111 (1 C):
    BNE     .Return     *   The instruction is not LEA

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayLea
* Description: Displays a LEA instruction word.
* Parameters : D1.W = The LEA instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayLea
    * D5.B = The address register number
    * D4.L = The effective address

.Registers  REG     D0-D5/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D5, and A1

    LEA     Lea,A1
    BSR     DisplayInstName     * Display the instruction name

    MOVE.W  D1,D5               * D5 = The address register number
    ANDI.W  #$0E00,D5           * Isolate bits 11, 10, and 9
    LSR.W   #8,D5               * Shift to occupy the least-significant bits
    LSR.W   #1,D5

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address
    MOVE.L  D0,D4               * D4 = The effective address

    MOVE.L  D4,D1
    MOVE.B  #%01100100,D3
    BSR     DisplayEA           * Display the effective address
    MOVE.B  D0,D2

    BSR     DisplayComma        * Display ','

    MOVE.B  D5,D1
    BSR     DisplayAddrDirect   * Display the address register destination

    MOVE.B  D0,D1
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    MOVEM.L (SP)+,.Registers    * Restore D0 to D5, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseNop
* Description: Determines if an instruction word is a NOP instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a NOP, 0 otherwise.
*------------------------------------------------------------------------------
ParseNop
    BSR     IsNop
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayNop

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsNop
* Description: Determines if an instruction word is a NOP instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a NOP, 0 otherwise.
*------------------------------------------------------------------------------
IsNop
    CLR.B   D0          * Set the return value to 0

    CMPI.W  #$4E71,D1   * If the instruction is not 4E71:
    BNE     .Return     *   The instruction is not NOP

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayNop
* Description: Displays a NOP instruction word.
* Parameters : D1.W = The NOP instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayNop
    MOVE.L  A1,-(SP)            * Preserve A1

    LEA     Nop,A1
    BSR     DisplayInstName     * Display the instruction name

    MOVE.L  (SP)+,A1            * Restore A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseRts
* Description: Determines if an instruction word is a RTS instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a RTS, 0 otherwise.
*------------------------------------------------------------------------------
ParseRts
    BSR     IsRts
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayRts

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsRts
* Description: Determines if an instruction word is a RTS instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a RTS, 0 otherwise.
*------------------------------------------------------------------------------
IsRts
    CLR.B   D0          * Set the return value to 0

    CMPI.W  #$4E75,D1   * If the instruction is not 4E75:
    BNE     .Return     *   The instruction is not RTS

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayRts
* Description: Displays a RTS instruction word.
* Parameters : D1.W = The RTS instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayRts
    MOVE.L  A1,-(SP)            * Preserve A1

    LEA     Rts,A1
    BSR     DisplayInstName     * Display the instruction name

    MOVE.L  (SP)+,A1            * Restore A1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
Jsr     DC.B    'JSR',0
Lea     DC.B    'LEA',0
Nop     DC.B    'NOP',0
Rts     DC.B    'RTS',0








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
