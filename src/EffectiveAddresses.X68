*------------------------------------------------------------------------------
* Title      : EffectiveAddresses
* Written by : Dillon Evans
* Date       : 5/22/23
* Description: Provides subroutines for handling effective addresses.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ExtractEA
* Description: Extracts the effective address from an instruction word.
* Parameters : D1.W = The instruction word.
*              D2.B = The starting bit of the effective address.
* Returns    : D0.L = The effective address.
*                     The most-significant word is the mode (0 - 7).
*                     The least-significant word is the register (0 - 7).
*------------------------------------------------------------------------------
ExtractEA
    MOVE.L  D3,-(SP)    * Preserve D3
    CLR.L   D0          * Clear the result
    MOVE.W  D1,D0       * Move the instruction into the result
    MOVE.W  #15,D3      * Word-sized shift left by (15 - D2),
    SUB.B   D2,D3       *   causing the EA to now start at bit 15,
    LSL.W   D3,D0       *   and removing all the bits before the EA
    LSL.L   #3,D0       * Long-sized shift left by 3,
                        *   causing the mode to be in the high-word,
                        *   while leaving the register in the low-word
    LSR.W   #7,D0       * Word-sized shift right by 13,
    LSR.W   #6,D0       *   causing the register to be at bit 2,
                        *   while leaving the mode untouched
    MOVE.L  (SP)+,D3    * Restore D3
    RTS                 * Return D0


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
