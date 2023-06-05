*------------------------------------------------------------------------------
* Title      : ParseMoveFamily
* Written by : Dillon Evans
* Date       : 6/5/23
* Description: Parses and displays the following instructions:
*              MOVE, MOVEA, MOVEQ
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseMove
* Description: Determines if an instruction word is an MOVE instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an MOVE, 0 otherwise.
*------------------------------------------------------------------------------
ParseMove
    BSR     IsMove
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayMove

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsMove
* Description: Determines if an instruction word is an MOVE instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an MOVE, 0 otherwise.
*------------------------------------------------------------------------------
IsMove
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$C000,D2   * Isolate the first 2 bits
    CMPI.W  #$0000,D2   * If the opcode does not start with 00 (0):
    BNE     .Return     *   The instruction is not MOVE

    MOVE.W  D1,D2
    ANDI.W  #$3000,D2   * Isolate the second 2 bits
    CMPI.W  #$0000,D2   * If the size is 0:
    BEQ     .Return     *   The instruction is not MOVE

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayMove
* Description: Displays an MOVE instruction word.
* Parameters : D1.W = The MOVE instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayMove
    * D6.B = The instruction size
    * D5.L = The destination effective address
    * D4.L = The source effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$3000,D6           * Isolate the second 2 bits
    LSR.W   #4,D6               * Shift to occupy the least-significant bits
    LSR.W   #8,D6

    MOVE.B  D6,D1
    BSR     StandardizeSize     * Standardize the instruction size
    MOVE.B  D0,D6

    LEA     Move,A1
    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.W  D3,D1               * Move the instruction back to D1

    MOVE.B  #11,D2
    BSR     ExtractEA           * Extract the destination effective address
    MOVE.L  D0,D5               * D5 = The destination effective address
    SWAP    D5

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the source effective address
    MOVE.L  D0,D4               * D4 = The source effective address

    MOVE.B  #%11111101,D1       * Supported addressing modes if byte
    MOVE.B  #%11111111,D2       * Supported addressing modes if not byte
    MOVE.B  D6,D3
    BSR     SetSuppModesBySize  * Set the supported addressing modes

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  D0,D3
    BSR     DisplayEA           * Display the source effective address
    MOVE.B  D0,D4

    BSR     DisplayComma        * Display ','

    MOVE.L  D5,D1
    MOVE.B  D6,D2
    MOVE.B  #%01111101,D3
    BSR     DisplayEA           * Display the destination effective address

    MOVE.B  D4,D1
    MOVE.B  D0,D2
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseMoveA
* Description: Determines if an instruction word is an MOVEA instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an MOVEA, 0 otherwise.
*------------------------------------------------------------------------------
ParseMoveA
    BSR     IsMoveA
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayMoveA

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsMoveA
* Description: Determines if an instruction word is an MOVEA instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an MOVEA, 0 otherwise.
*------------------------------------------------------------------------------
IsMoveA
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$C000,D2   * Isolate the first 2 bits
    CMPI.W  #$0000,D2   * If the opcode does not start with 00 (0):
    BNE     .Return     *   The instruction is not MOVEA

    MOVE.W  D1,D2
    ANDI.W  #$01C0,D2   * Isolate bits 8, 7, and 6
    CMPI.W  #$0040,D2   * If the bits are not 001 (0 4):
    BNE     .Return     *   The instruction is not MOVEA

    BTST.L  #13,D1      * If bit 13 is 0:
    BEQ     .Return     *   The instruction is not MOVEA

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayMoveA
* Description: Displays an MOVEA instruction word.
* Parameters : D1.W = The MOVEA instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayMoveA
    * D6.B = The instruction size
    * D5.B = The address register number
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$3000,D6           * Isolate the second 2 bits
    LSR.W   #4,D6               * Shift to occupy the least-significant bits
    LSR.W   #8,D6

    MOVE.B  D6,D1
    BSR     StandardizeSize     * Standardize the instruction size
    MOVE.B  D0,D6

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     MoveA,A1
    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.W  D3,D1               * Move the instruction back to D1

    MOVE.W  D1,D5               * D5 = The address register number
    ANDI.W  #$0E00,D5           * Isolate bits 11, 10, and 9
    LSR.W   #8,D5               * Shift to occupy the least-significant bits
    LSR.W   #1,D5

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address
    MOVE.L  D0,D4               * D4 = The effective address

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  #%11111111,D3
    BSR     DisplayEA           * Display the effective address source
    MOVE.B  D0,D2

    BSR     DisplayComma        * Display ','

    MOVE.B  D5,D1
    BSR     DisplayAddrDirect   * Display the address register destination

    MOVE.B  D0,D1
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseMoveQ
* Description: Determines if an instruction word is an MOVEQ instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an MOVEQ, 0 otherwise.
*------------------------------------------------------------------------------
ParseMoveQ
    BSR     IsMoveQ
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayMoveQ

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsMoveQ
* Description: Determines if an instruction word is an MOVEQ instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an MOVEQ, 0 otherwise.
*------------------------------------------------------------------------------
IsMoveQ
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$7000,D2   * If the opcode is not 0111 (7):
    BNE     .Return     *   The instruction is not MOVEQ

    BTST.L  #8,D1      * If bit 8 is 1:
    BNE     .Return     *   The instruction is not MOVEQ

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayMoveQ
* Description: Displays an MOVEQ instruction word.
* Parameters : D1.W = The MOVEQ instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayMoveQ
    * D5.B = The data register number
    * D4.B = The immediate data

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    LEA     MoveQ,A1
    BSR     DisplayInstName     * Display the instruction name

    MOVE.W  D1,D5               * D5 = The data register number
    ANDI.W  #$0E00,D5           * Isolate bits 11, 10, and 9
    LSR.W   #8,D5               * Shift to occupy the least-significant bits
    LSR.W   #1,D5

    MOVE.B  D1,D4               * D4 = The immediate data

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  D4,D1
    BSR     DisplayImmediateByte    * Display the immediate data

    BSR     DisplayComma        * Display ','

    MOVE.B  D5,D1
    BSR     DisplayDataDirect   * Display the data register source

    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
Move    DC.B    'MOVE',0,0
MoveA   DC.B    'MOVEA',0
MoveQ   DC.B    'MOVEQ',0







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
