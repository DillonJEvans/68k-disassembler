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
* Subroutine : GetAddressingMode
* Description: Determines the addressing mode represented by the effective
*              address.
* Parameters : D1.L = The effective address.
* Returns    : D0.B = The addressing mode.
*                     0 = Dn          3 = (An)+           6 = (xxx).L
*                     1 = An          4 = -(An)           7 = #<data>
*                     2 = (An)        5 = (xxx).W        -1 = Unsupported
*------------------------------------------------------------------------------
GetAddressingMode
    SWAP    D1                  * Prepare to do comparisons with the EA's mode

    CMPI.B  #4,D1               * If mode <= 4:
    BLE     .RegisterMode       *   Return mode
    CMPI.B  #7,D1               * If mode < 7:
    BLT     .Unsupported        *   Return -1
    SWAP    D1                  * Prepare to do comparions with the EA's reg
    CMPI.B  #0,D1               * If register == 0:
    BEQ     .AddressingWord     *   Return 5
    CMPI.B  #1,D1               * If register == 1:
    BEQ     .AddressingLong     *   Return 6
    CMPI.B  #4,D1               * If register == 4:
    BEQ     .ImmediateData      *   Return 7
    SWAP    D1                  * Swap D1 so the mode is in the low-byte to
                                *   match the swap in Unsupported
    BRA     .Unsupported        * Return -1

.RegisterMode                   * Mode <= 4
    MOVE.B  D1,D0
    SWAP    D1                  * Swap the EA back before returning
    RTS                         * Return mode

.AddressingWord                 * Mode == 7 and Register == 0
    MOVE.B  #5,D0
    RTS                         * Return 5

.AddressingLong                 * Mode == 7 and Register == 1
    MOVE.B  #6,D0
    RTS                         * Return 6

.ImmediateData                  * Mode == 7 and Register == 4
    MOVE.B  #7,D0
    RTS

.Unsupported                    * Else
    MOVE.B  #-1,D0
    SWAP    D1                  * Swap the EA back before returning
    RTS                         * Return -1


*------------------------------------------------------------------------------
* Subroutine : IsModeSupported
* Description: Determines if the addressing mode is supported for a specific
*              effective address.
* Parameters : D1.B = The addressing mode.
*              D2.B = The bit field of supported addressing modes.
* Returns    : The Z-bit in the CCR is 1 if the mode is supported; 0 otherwise.
* Notes      : The bit field of addressing modes maps each bit like so:
*              0 = Dn          3 = (An)+           6 = (xxx).L
*              1 = An          4 = -(An)           7 = #<data>
*              2 = (An)        5 = (xxx).W
*------------------------------------------------------------------------------
IsModeSupported
    BTST.B  D1,D2
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
