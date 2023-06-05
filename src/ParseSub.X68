*------------------------------------------------------------------------------
* Title      : ParseSub
* Written by : Dillon Evans
* Date       : 6/5/23
* Description: Parses and displays the following instructions:
*              SUB
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseSub
* Description: Determines if an instruction word is a SUB instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a SUB, 0 otherwise.
*------------------------------------------------------------------------------
ParseSub
    BSR     IsSub
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplaySub

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsSub
* Description: Determines if an instruction word is a SUB instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a SUB, 0 otherwise.
*------------------------------------------------------------------------------
IsSub
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$9000,D2   * If the opcode is not 1001 (9):
    BNE     .Return     *   The instruction is not SUB

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2   * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2   * If the size is 3:
    BEQ     .Return     *   The instruction is not SUB

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplaySub
* Description: Displays a SUB instruction word.
* Parameters : D1.W = The SUB instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplaySub
    * D6.B = The instruction size
    * D5.B = The data register number
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     Sub,A1
    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.W  D3,D1               * Move the instruction back to D1

    MOVE.W  D1,D5               * D5 = The data register number
    ANDI.W  #$0E00,D5           * Isolate bits 11, 10, and 9
    LSR.W   #8,D5               * Shift to occupy the least-significant bits
    LSR.W   #1,D5

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address
    MOVE.L  D0,D4               * D4 = The effective address

    BTST.L  #8,D1               * If the direction is 0:
    BEQ     .EAIsSource         *   EA is the source
    BRA     .EAIsDestination    * Else:
                                *   EA is the destination

.EAIsSource
    MOVE.B  #%11111101,D1       * Supported addressing modes if byte
    MOVE.B  #%11111111,D2       * Supported addressing modes if not byte
    MOVE.B  D6,D3
    BSR     SetSuppModesBySize  * Set the supported addressing modes

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  D0,D3
    BSR     DisplayEA           * Display the effective address source
    MOVE.B  D0,D2

    BSR     DisplayComma        * Display ','

    MOVE.B  D5,D1
    BSR     DisplayDataDirect   * Display the data register destination

    MOVE.B  D0,D1
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    BRA     .Return

.EAIsDestination
    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  D5,D1
    BSR     DisplayDataDirect   * Display the data register source

    BSR     DisplayComma        * Display ','

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  #%01111100,D3
    BSR     DisplayEA           * Display the effective address destination

    MOVE.B  #2,D1
    MOVE.B  D0,D2
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    BRA     .Return

.Return
    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
Sub     DC.B    'SUB',0










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
