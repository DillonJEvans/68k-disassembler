*------------------------------------------------------------------------------
* Title      : ParseInstructions
* Written by : Dillon Evans
* Date       : 6/2/23
* Description: Provides subroutines for parsing instructions to strings.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseAdd
* Description: Determines if an instruction word is an ADD instruction,
*              and if so, converts it to instruction and operand strings.
* Parameters : D6.W = The instruction word.
*               A1  = The location to store the instruction string at.
*               A2  = The location to store the operand string at.
* Returns    : D0.B = 1 if the instruction was an ADD, 0 otherwise.
*              (A1) = The instruction string if the instruction was an ADD.
*              (A2) = The operand string if the instruction was an ADD.
*------------------------------------------------------------------------------
ParseAdd
    * D6 = The instruction word
    * D5 = The instruction size
    * D4 = The effective address
    * D3 = The addressing mode

    CLR.B   D0

    MOVE.W  D6,D1
    ANDI.W  #$F000,D1           * Isolate the first 4 bits of the instruction
    CMPI.W  #$D000,D1           * If the opcode is not 1101 (D):
    BNE     .Return             *   The instruction is not ADD

    MOVE.W  D6,D5               * D5 = The instruction size
    ANDI.W  #$00C0,D5           * Isolate bits 7 and 6
    LSR.W   #6,D5               * Shift the size to occupy the least-significant bits
    CMPI.B  #3,D5               * If the size is 3:
    BEQ     .Return             *   The instruction is not ADD

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address
    MOVE.L  D0,D4               * D4 = The effective address

    MOVE.L  D4,D1
    BSR     GetAddressingMode   * Get addressing mode
    MOVE.B  D0,D3               * D3 = The addressing mode (temporarily)

    BTST.W  #8,D6               * If the direction is 0:
    BEQ     .EAIsSource         *   EA is the source
    BRA     .EAIsDestination    * Else:
                                *   EA is the destination

.EAIsSource

.EAIsDestination

.Return
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
