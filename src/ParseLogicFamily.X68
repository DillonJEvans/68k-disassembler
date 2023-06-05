*------------------------------------------------------------------------------
* Title      : ParseLogicFamily
* Written by : Dillon Evans
* Date       : 6/5/23
* Description: Parses and displays the following instructions:
*              AND, OR, NOT
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseAnd
* Description: Determines if an instruction word is an AND instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an AND, 0 otherwise.
*------------------------------------------------------------------------------
ParseAnd
    BSR     IsAnd
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayAnd

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsAnd
* Description: Determines if an instruction word is an AND instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an AND, 0 otherwise.
*------------------------------------------------------------------------------
IsAnd
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$C000,D2   * If the opcode is not 1100 (C):
    BNE     .Return     *   The instruction is not AND

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2   * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2   * If the size is 3:
    BEQ     .Return     *   The instruction is not AND

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAnd
* Description: Displays an AND instruction word.
* Parameters : D1.W = The AND instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAnd
    * D6.B = The instruction size
    * D5.B = The data register number
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     And,A1
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
    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  #%11111101,D3
    BSR     DisplayEA           * Display the effective address source
    MOVE.B  D0,D2

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  #',',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display ','

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

    MOVE.B  #',',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display ','

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
* Subroutine : ParseOr
* Description: Determines if an instruction word is an OR instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an OR, 0 otherwise.
*------------------------------------------------------------------------------
ParseOr
    BSR     IsOr
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayOr

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsOr
* Description: Determines if an instruction word is an OR instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an OR, 0 otherwise.
*------------------------------------------------------------------------------
IsOr
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$8000,D2   * If the opcode is not 1000 (8):
    BNE     .Return     *   The instruction is not OR

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2   * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2   * If the size is 3:
    BEQ     .Return     *   The instruction is not OR

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayOr
* Description: Displays an OR instruction word.
* Parameters : D1.W = The OR instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayOr
    * D6.B = The instruction size
    * D5.B = The data register number
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     Or,A1
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
    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  #%11111101,D3
    BSR     DisplayEA           * Display the effective address source
    MOVE.B  D0,D2

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  #',',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display ','

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

    MOVE.B  #',',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display ','

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
* Subroutine : ParseNot
* Description: Determines if an instruction word is an NOT instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an NOT, 0 otherwise.
*------------------------------------------------------------------------------
ParseNot
    BSR     IsNot
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayNot

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsNot
* Description: Determines if an instruction word is an NOT instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an NOT, 0 otherwise.
*------------------------------------------------------------------------------
IsNot
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$4000,D2   * If the opcode is not 0100 (4):
    BNE     .Return     *   The instruction is not NOT

    MOVE.W  D1,D2
    ANDI.W  #$0F00,D2   * Isolate the second 4 bits
    CMPI.W  #$0600,D2   * If the second 4 bits are not 0110 (6):
    BNE     .Return     *   The instruction is not NOT

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2   * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2   * If the size is 3:
    BEQ     .Return     *   The instruction is not NOT

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayNot
* Description: Displays an NOT instruction word.
* Parameters : D1.W = The NOT instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayNot
    * D6.B = The instruction size
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     Not,A1
    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.W  D3,D1               * Move the instruction back to D1

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address
    MOVE.L  D0,D4               * D4 = The effective address

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  #%01111101,D3
    BSR     DisplayEA           * Display the effective address source

    MOVE.B  D0,D1
    CLR.B   D2
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
And     DC.B    'AND',0
Or      DC.B    'OR',0,0
Not     DC.B    'NOT',0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
