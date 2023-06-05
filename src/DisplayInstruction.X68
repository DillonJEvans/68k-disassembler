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

    * Add Family
    BSR     ParseAdd        * If the instruction is an ADD:
    CMPI.B  #1,D0           *   Display the instruction as an ADD
    BEQ     .Return         *   Return
    BSR     ParseAddA       * If the instruction is an ADDA:
    CMPI.B  #1,D0           *   Display the instruction as an ADDA
    BEQ     .Return         *   Return
    BSR     ParseAddQ       * If the instruction is an ADDQ:
    CMPI.B  #1,D0           *   Display the instruction as an ADDQ
    BEQ     .Return         *   Return

    * Logic Family
    BSR     ParseAnd        * If the instruction is an AND:
    CMPI.B  #1,D0           *   Display the instruction as an AND
    BEQ     .Return         *   Return
    BSR     ParseOr         * If the instruction is an OR:
    CMPI.B  #1,D0           *   Display the instruction as an OR
    BEQ     .Return         *   Return
    BSR     ParseNot        * If the instruction is an NOT:
    CMPI.B  #1,D0           *   Display the instruction as an NOT
    BEQ     .Return         *   Return

    BSR     DisplayData     * Display the instruction word as data

.Return
    MOVE.L  (SP)+,D0        * Restore D0
    RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
