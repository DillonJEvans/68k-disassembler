*------------------------------------------------------------------------------
* Title      : DisplaySize
* Written by : Dillon Evans
* Date       : 6/4/23
* Description: Displays the size modifier of an instruction.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DisplaySize
* Description: Displays the size modifier of an instruction.
* Parameters : D1.B = The instruction size.
*                     0 = byte, 1 = word, 2 = long.
* Returns    : None.
*------------------------------------------------------------------------------
DisplaySize
    MOVE.L  D2,-(SP)    * Preserve D2

    MOVE.B  D1,D2       * Move the size into D2

    MOVE.B  #6,D0
    MOVE.B  #'.',D1
    TRAP    #15         * Display '.'

    CMPI.B  #1,D2
    BLT     .Byte       * If size is 0: byte
    BEQ     .Word       * If size is 1: word
    BGT     .Long       * If size is 2: long

.Byte
    MOVE.B  'B',D1      * Prepare to display 'B'
    BRA     .Return

.Word
    MOVE.B  'W',D1      * Prepare to display 'W'
    BRA     .Return

.Long
    MOVE.B  'L',D1      * Prepare to display 'L'
    BRA     .Return

.Return
    TRAP    #15         * Display the size character
    MOVE.B  D2,D1       * Move the size back into D1
    MOVE.L  (SP)+,D2    * Restore D2
    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
