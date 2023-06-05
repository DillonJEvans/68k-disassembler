*------------------------------------------------------------------------------
* Title      : ParseBraFamily
* Written by : Dillon Evans
* Date       : 6/5/23
* Description: Parses and displays the following instructions:
*              BRA, Bcc
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseBra
* Description: Determines if an instruction word is a BRA instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a BRA, 0 otherwise.
*------------------------------------------------------------------------------
ParseBra
    BSR     IsBra
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayBra

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsBra
* Description: Determines if an instruction word is a BRA instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a BRA, 0 otherwise.
*------------------------------------------------------------------------------
IsBra
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$FF00,D2   * Isolate the first 8 bits
    CMPI.W  #$6000,D2   * If the first 8 bits are not 60:
    BNE     .Return     *   The instruction is not BRA

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayBra
* Description: Displays a BRA instruction word.
* Parameters : D1.W = The BRA instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayBra

.Registers  REG     D0-D1/A1

    MOVEM.L .Registers,-(SP)        * Preserve D0, D1, and A1

    LEA     Bra,A1
    BSR     DisplayInstName         * Display the instruction name

    BSR     GetBranchDestination    * Get the destination

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor            * Set the text color to operand color

    MOVE.L  A0,D1
    BSR     DisplayAbsAddrLong      * Display the destination

    MOVEM.L (SP)+,.Registers        * Restore D0, D1, and A1
    RTS
    

*------------------------------------------------------------------------------
* Subroutine : ParseBcc
* Description: Determines if an instruction word is a Bcc instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a Bcc, 0 otherwise.
*------------------------------------------------------------------------------
ParseBcc
    BSR     IsBcc
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayBcc

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsBcc
* Description: Determines if an instruction word is a Bcc instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a Bcc, 0 otherwise.
*------------------------------------------------------------------------------
IsBcc
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$6000,D2   * If the opcode is not 0110 (6):
    BNE     .Return     *   The instruction is not Bcc

    MOVE.W  D1,D2
    ANDI.W  #$0F00,D2   * Isolate the second 4 bits
    CMPI.W  #$0200,D2   * If the bits are 0000 (0) or 0001 (1):
    BLT     .Return     *   The instruction is not Bcc

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayBcc
* Description: Displays a Bcc instruction word.
* Parameters : D1.W = The Bcc instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayBcc

.Registers  REG     D0-D1/A1

    MOVEM.L .Registers,-(SP)        * Preserve D0, D1, and A1

    BSR     DisplayBccName          * Display the instruction name

    BSR     GetBranchDestination    * Get the destination

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor            * Set the text color to operand color

    MOVE.L  A0,D1
    BSR     DisplayAbsAddrLong      * Display the destination

    MOVEM.L (SP)+,.Registers        * Restore D0, D1, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : GetBranchDestination
* Description: Gets the destination of a branch instruction by extracting it's
*              displacement.
* Parameters : D1.W = The branch instruction word.
* Returns    :  A0  = The destination.
*------------------------------------------------------------------------------
GetBranchDestination
    MOVE.L  D0,-(SP)    * Preserve D0
    MOVEA.L A5,A0       * Save the PC before reading extension words

    CMPI.B  #$00,D1     * If the 8-bit displacement is $00:
    BEQ     .WordDisp   *   Word displacement
    CMPI.B  #$FF,D1     * If the 8-bit displacement is $FF:
    BEQ     .LongDisp   *   Long displacement

    MOVE.B  D1,D0       * Sign-extend the 8-bit displacement
    EXT.W   D0
    EXT.L   D0
    BRA     .Return

.WordDisp
    MOVE.W  (A5)+,D0    * Read in an extension word
    EXT.L   D0          * Sign-extend the 16-bit displacement
    BRA     .Return

.LongDisp
    MOVE.L  (A5)+,D0    * Read in two extension words

.Return
    ADDA.L  D0,A0
    MOVE.L  (SP)+,D0    * Restore D0
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayBccName
* Description: Displays the instruction name of a Bcc instruction.
* Parameters : D1.W = The Bcc instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayBccName

.Registers  REG     D0-D2/A1

    MOVEM.L .Registers,-(SP)        * Preserve D0, D1, D2, and A1
    MOVE.W  D1,D2                   * Save the instruction in D2

    MOVE.L  #InstructionColor,D1
    BSR     SetTextColor            * Set the text color to instruction color

    MOVE.B  #'B',D1
    MOVE.B  #6,D0
    TRAP    #15                     * Display 'B'

    CLR.L   D1                      * Make sure the high word is clear
    MOVE.W  D2,D1
    ANDI.W  #$0F00,D1               * Isolate the second 4 bits
    LSR.W   #6,D1                   * Shift to occupy the least-significant
                                    * bits and multiply by 4 at the same time

    LEA     Conditionals,A1         * Use the condition code as the index for
    ADDA.L  D1,A1                   * a long-sized jump table of condition
    MOVE.B  #14,D0                  * strings
    TRAP    #15                     * Display the conditional

    MOVE.B  #5,D1
    BSR     DisplaySpaces           * Display 5 spaces

    MOVEM.L (SP)+,.Registers        * Restore D0, D1, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
Bra             DC.B    'BRA',0
Conditionals    DC.B    'T ',0,0    * 0000 = 0
                DC.B    'F ',0,0    * 0001 = 1
                DC.B    'HI',0,0    * 0010 = 2
                DC.B    'LS',0,0    * 0011 = 3
                DC.B    'CC',0,0    * 0100 = 4
                DC.B    'CS',0,0    * 0101 = 5
                DC.B    'NE',0,0    * 0110 = 6
                DC.B    'EQ',0,0    * 0111 = 7
                DC.B    'VC',0,0    * 1000 = 8
                DC.B    'VS',0,0    * 1001 = 9
                DC.B    'PL',0,0    * 1010 = A
                DC.B    'MI',0,0    * 1011 = B
                DC.B    'GE',0,0    * 1100 = C
                DC.B    'LT',0,0    * 1101 = D
                DC.B    'GT',0,0    * 1110 = E
                DC.B    'LE',0,0    * 1111 = F







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
