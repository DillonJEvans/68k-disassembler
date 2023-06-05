*------------------------------------------------------------------------------
* Title      : DisplayMisc
* Written by : Dillon Evans
* Date       : 6/4/23
* Description: Provides a variety of miscellaneous display subroutines.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DisplayAddress
* Description: Displays the current address of the disassembler.
* Parameters : D1.L = The address.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAddress

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2

    MOVE.L  #AddressColor,D1
    BSR     SetTextColor        * Set the text color to address color

    MOVE.L  D2,D1

    SUBA.L  #16,SP
    MOVEA.L SP,A1               * Allocate 16 bytes for the address string

    MOVE.B  #8,D2
    BSR     IntToHex            * Add the address to the string
    MOVE.L  #'    ',(8,A1)      * Add '    ' to the string
    CLR.B   (12,A1)             * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15                 * Display the address string

    ADDA.L  #16,SP              * Deallocate 16 bytes for the address string
    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayData
* Description: Displays a word as data.
* Parameters : D1.W = The data word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayData

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2

    SUBQ.L  #8,SP
    MOVEA.L SP,A1               * Allocate 8 bytes for a string

    MOVE.L  #DataLabelColor,D1
    BSR     SetTextColor        * Set the text color to data label color

    MOVE.L  #'DATA',(A1)        * Add 'DATA' to the string
    CLR.B   (4,A1)              * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15                 * Display the 'DATA' string

    MOVE.B  #4,D1
    BSR     DisplaySpaces       * Display 4 spaces

    MOVE.L  #DataHexColor,D1
    BSR     SetTextColor        * Set the text color to data hex color

    MOVE.B  #'$',(A1)+          * Add '$' to a new string
    MOVE.L  D2,D1
    MOVE.B  #4,D2
    BSR     IntToHex            * Add the data word to the string
    SUBQ.L  #1,D1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the data string

    ADDQ.L  #8,SP               * Deallocate 8 bytes for a string
    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


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
    MOVE.B  #'B',D1     * Prepare to display 'B'
    BRA     .Return

.Word
    MOVE.B  #'W',D1     * Prepare to display 'W'
    BRA     .Return

.Long
    MOVE.B  #'L',D1     * Prepare to display 'L'
    BRA     .Return

.Return
    TRAP    #15         * Display the size character
    MOVE.B  D2,D1       * Move the size back into D1
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayUnsupported
* Description: Displays the unsupported message if necessary.
* Parameters : D1.B = The length of the first operand string displayed.
*              D2.B = The length of the second operand string displayed.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayUnsupported

.Registers  REG     D0-D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D1, D2, and A1

.FirstOperand
    CMPI.B  #0,D1               * If D1 is positive:
    BGE     .SecondOperand      *   Check D2
    NOT.B   D1                  * Else:
    CMPI.B  #0,D2               *   NOT D1
    BGE     .Unsupported        *   If D2 is negative:
    NOT.B   D2                  *       NOT D2
    BRA     .Unsupported        *   Display the unsupported EA message

.SecondOperand
    CMPI.B  #0,D2               * If D2 is negative:
    BGE     .Return             *   NOT D2
    NOT.B   D2                  *   Display the unsupported EA message

.Unsupported
    ADD.B   D2,D1
    NEG.B   D1
    ADDI.B  #24,D1
    BSR     DisplaySpaces       * Display 24 - D1 - D2 spaces

    MOVE.L  #InvalidEAColor,D1
    BSR     SetTextColor        * Set the text color to invalid EA color

    LEA     UnsupportedMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Display the unsupported EA message

.Return
    MOVEM.L (SP)+,.Registers    * Restore D0, D1, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
UnsupportedMsg  DC.B    'Unsupported Effective Address',0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
