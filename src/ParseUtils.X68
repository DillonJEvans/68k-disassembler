*------------------------------------------------------------------------------
* Title      : ParseUtils
* Written by : Dillon Evans
* Date       : 6/5/23
* Description: Provides a variety of helpful instruction parsing utility
*              subroutines.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DisplayComma
* Description: Displays a comma (and sets the text color to operand color).
* Parameters : None.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayComma

.Registers  REG     D0-D1

    MOVEM.L .Registers,-(SP)    * Preserve D0 and D1

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  #',',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display ','

    MOVEM.L (SP)+,.Registers    * Restore D0 and D1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayInstName
* Description: Displays an instruction name.
* Parameters : (A1) = The instruction name as a null terminated string.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayInstName

.Registers  REG     D0-D1

    MOVEM.L .Registers,-(SP)        * Preserve D0 and D1
    MOVE.B  D1,D0                   * Store the size in D0 for now

    MOVE.L  #InstructionColor,D1
    BSR     SetTextColor            * Set the text color to instruction color

    MOVE.B  D0,D1                   * Move the size back to D1

    MOVE.B  #14,D0
    TRAP    #15                     * Display the instruction name

    BSR     StringLength            * Get the length of the instruction name
    MOVE.B  #8,D1
    SUB.B   D0,D1
    BSR     DisplaySpaces           * Display (8 - strlen) spaces

    MOVEM.L (SP)+,.Registers        * Restore D0 and D1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayInstAndSize
* Description: Displays an instruction name and it's size modifier.
* Parameters : (A1) = The instruction name as a null terminated string.
*              D1.B = The instruction size.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayInstAndSize

.Registers  REG     D0-D1

    MOVEM.L .Registers,-(SP)        * Preserve D0 and D1
    MOVE.B  D1,D0                   * Store the size in D0 for now

    MOVE.L  #InstructionColor,D1
    BSR     SetTextColor            * Set the text color to instruction color

    MOVE.B  D0,D1                   * Move the size back to D1

    MOVE.B  #14,D0
    TRAP    #15                     * Display the instruction name

    BSR     DisplaySize             * Display the size modifier

    BSR     StringLength            * Get the length of the instruction name
    MOVE.B  #6,D1
    SUB.B   D0,D1
    BSR     DisplaySpaces           * Display (8 - 2 - strlen) spaces

    MOVEM.L (SP)+,.Registers        * Restore D0 and D1
    RTS


*------------------------------------------------------------------------------
* Subroutine : SetSuppModesBySize
* Description: Sets the supported modes based on whether the instruction size
*              is byte or not.
* Parameters : D1.B = The supported modes if the instruction size is byte.
*              D2.B = The supported modes if the instruction size is not byte.
*              D3.B = The instruction size.
* Returns    : D0.B = The supported modes.
*------------------------------------------------------------------------------
SetSuppModesBySize
    CMPI.B  #0,D3   * If the size is byte:
    BEQ     .Byte   *   Return D1
    MOVE.B  D2,D0   * Else:
    RTS             *   Return D2

.Byte
    MOVE.B  D1,D0   * Return D1
    RTS


*------------------------------------------------------------------------------
* Subroutine : StandardizeSize
* Description: Changes the instruction size as follows:
*              byte = 01 -> 00      word = 11 -> 01      long = 10 -> 10
* Parameters : D1.B = The non-standard instruction size.
* Returns    : D0.B = The standard instruction size.
*------------------------------------------------------------------------------
StandardizeSize
    MOVE.B  D1,D0
    CMPI.B  #2,D1       * If the size is long:
    BEQ     .Return     *   Return (long is already standard)
    LSR.B   #1,D0       * Else:
                        *   Shift right 1 to standardize byte/word

.Return
    RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
