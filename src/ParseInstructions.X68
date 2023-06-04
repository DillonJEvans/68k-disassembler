*------------------------------------------------------------------------------
* Title      : ParseInstructions
* Written by : Dillon Evans
* Date       : 6/2/23
* Description: Provides subroutines for parsing instructions to strings.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseAdd
* Description: Determines if an instruction word is an ADD instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an ADD, 0 otherwise.
*------------------------------------------------------------------------------
ParseAdd
    BSR     IsAdd
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayAdd

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsAdd
* Description: Determines if an instruction word is an ADD instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an ADD, 0 otherwise.
*------------------------------------------------------------------------------
IsAdd
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$D000,D2   * If the opcode is not 1101 (D):
    BNE     .Return     *   The instruction is not ADD

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2   * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2   * If the size is 3:
    BEQ     .Return     *   The instruction is not ADD

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAdd
* Description: Displays an ADD instruction word.
* Parameters : D1.W = The ADD instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
Add     DC.B    'ADD',0

DisplayAdd
    * D6.B = The instruction size
    * D5.B = The data register number
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    MOVE.L  #InstructionColor,D1
    BSR     SetTextColor        * Set the text color to instruction color

    LEA     Add,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Display 'ADD'

    MOVE.B  D6,D1
    BSR     DisplaySize         * Display the size modifier

    MOVE.B  #3,D1
    BSR     DisplaySpaces       * Display 3 spaces

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
    CMPI.B  #0,D6               * If the size is byte:
    BEQ     .ByteSize           *   Don't support address register direct
    BRA     .NonByteSize        * Else:
                                *   Support address register direct

.ByteSize
    MOVE.B  #%11111101,D3
    BRA     .EAIsSourceCont

.NonByteSize
    MOVE.B  #%11111111,D3
    BRA     .EAIsSourceCont

.EAIsSourceCont
    MOVE.L  D4,D1
    MOVE.B  D6,D2
    BSR     DisplayEA           * Display the effective address source

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  #',',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display ','

    MOVE.B  D5,D1
    BSR     DisplayDataDirect   * Display the data register source

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

    BRA     .Return

.Return
    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Variables
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Equates
*------------------------------------------------------------------------------









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
