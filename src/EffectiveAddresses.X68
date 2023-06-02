*------------------------------------------------------------------------------
* Title      : EffectiveAddresses
* Written by : Dillon Evans
* Date       : 5/22/23
* Description: Provides subroutines for handling effective addresses.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* NOTES
*
* Effective Addresses:
*   An effective address is stored in a single longword data register.
*   The most-significant word of the long is the mode.
*   The least-significant word of the long is the register.
*   This is done to keep the mode and register together, rather than in
*   separate data registers, and to make it easy to check their values by using
*   SWAP along with word or byte sized comparisons.
*
* Addressing Modes:
*   An addressing mode is stored in a byte of a data register.
*   Although similar, this is NOT the same as the mode of an effective address.
*   An addressing mode is a value from 0 to 7 that represents which addressing
*   mode an effective address is.
*   This table shows the addressing modes and their corresponding EAs:
*       0 = Dn          3 = (An)+           6 = (xxx).L
*       1 = An          4 = -(An)           7 = #<data>
*       2 = (An)        5 = (xxx).W        -1 = Unsupported
*   This is primarily used to identify if the addressing mode of an effective
*   address is supported or not by a specific instruction.
*
* Bit Field of Supported Addressing Modes:
*   A bit field is stored in a byte of a data register (or as immediate data).
*   The purpose of a bit field is store 8 booleans: 1 for each addressing mode,
*   with each boolean representing whether that addressing mode is supported or
*   not by the specific instruction.
*   The bits in a bit field correspond directly with addressing modes.
*   This table shows the bits and their corresponding addressing modes:
*       0 = Dn          3 = (An)+           6 = (xxx).L
*       1 = An          4 = -(An)           7 = #<data>
*       2 = (An)        5 = (xxx).W
*   This makes it easy to check if an addressing mode is supported, by placing
*   the addressing mode in a data register, and then doing:
*       BTST.B  Dn,#<bit field as immediate data>
*   or by using the IsModeSupported subroutine (which does the above).
*   For example, the bit field of #%01111101 indicates that the EA supports
*   all addressing modes except for immediate data and address register direct.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ExtractEA
* Description: Extracts the effective address from an instruction word.
* Parameters : D1.W = The instruction word.
*              D2.B = The starting bit of the effective address.
* Returns    : D0.L = The effective address.
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
* Returns    : The Z-bit in the CCR is 0 if the mode is supported; 1 otherwise.
*------------------------------------------------------------------------------
IsModeSupported
    BTST.L  D1,D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : CountExtWords
* Description: Counts how many extension words are required for an effective
*              address.
* Parameters : D1.B = The addressing mode.
*              D2.B = The size of the instruction.
*                     0 = byte, 1 = word, 2 = long.
* Returns    : D0.B = The number of extension words needed for the EA.
*------------------------------------------------------------------------------
CountExtWords
    CMPI.B  #4,D1           * If mode <= 4:
    BLE     .ZeroExtWords   *   Return 0
    CMPI.B  #7,D1           * If mode < 7:
    BLT     .AbsoluteMode   *   Return (mode - 4)
    MOVE.B  D2,D0           * Else:
    LSR.B   #1,D0           *   Return 1 for sizes 0 and 1
    ADDQ.B  #1,D0           *   Return 2 for size 2
    RTS

.ZeroExtWords
    MOVE.B  #0,D0
    RTS                     * Return 0

.AbsoluteMode
    MOVE.B  D1,D0           * Mode 5 returns 1
    SUBQ.B  #4,D0           * Mode 6 returns 2
    RTS                     * So just return mode - 4


*------------------------------------------------------------------------------
* Subroutine : EAToString
* Description: Converts an effective address to a string.
* Parameters : D1.L = The effective address.
*              D2.B = The size of the instruction.
*                     0 = byte, 1 = word, 2 = long.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
