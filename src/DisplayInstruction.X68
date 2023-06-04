*------------------------------------------------------------------------------
* Title      : DisplayInstruction
* Written by : Dillon Evans
* Date       : 6/4/23
* Description: Displays an instruction word.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DisplayInstruction
* Description: Displays an instruction word.
* Parameters : D1.W = The instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayInstruction
    MOVE.L  D0,-(SP)        * Preserve D0

    BSR     ParseAdd        * If the instruction is an ADD:
    CMPI.B  #1,D0           *   Display the instruction as an ADD
    BEQ     .Return         *   Return

    BSR     DisplayData     * Display the instruction word as data

.Return
    MOVE.L  (SP)+,D0        * Restore D0
    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
