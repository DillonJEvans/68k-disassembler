*------------------------------------------------------------------------------
* Title      : ParseAddFamily
* Written by : Dillon Evans
* Date       : 6/2/23
* Description: Parses and displays the following instructions:
*              ADD, ADDA, ADDQ
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
DisplayAdd
    * D6.B = The instruction size
    * D5.B = The data register number
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     Add,A1
    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

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
    MOVE.B  #%11111101,D1       * Supported addressing modes if byte
    MOVE.B  #%11111111,D2       * Supported addressing modes if not byte
    MOVE.B  D6,D3
    BSR     SetSuppModesBySize  * Set the supported addressing modes

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  D0,D3
    BSR     DisplayEA           * Display the effective address source
    MOVE.B  D0,D2

    BSR     DisplayComma        * Display ','

    MOVE.B  D5,D1
    BSR     DisplayDataDirect   * Display the data register destination

    MOVE.B  D0,D1
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    BRA     .Return

.EAIsDestination
    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  D5,D1
    BSR     DisplayDataDirect   * Display the data register source

    BSR     DisplayComma        * Display ','

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  #%01111100,D3
    BSR     DisplayEA           * Display the effective address destination

    MOVE.B  #2,D1
    MOVE.B  D0,D2
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    BRA     .Return

.Return
    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseAddA
* Description: Determines if an instruction word is an ADDA instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an ADDA, 0 otherwise.
*------------------------------------------------------------------------------
ParseAddA
    BSR     IsAddA
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayAddA

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsAddA
* Description: Determines if an instruction word is an ADDA instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an ADDA, 0 otherwise.
*------------------------------------------------------------------------------
IsAddA
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$D000,D2   * If the opcode is not 1101 (D):
    BNE     .Return     *   The instruction is not ADDA

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2   * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2   * If the bits are not 3:
    BNE     .Return     *   The instruction is not ADDA

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddA
* Description: Displays an ADDA instruction word.
* Parameters : D1.W = The ADDA instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAddA
    * D6.B = The instruction size
    * D5.B = The address register number
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$0100,D6           * Isolate bit 8
    LSR.W   #8,D6               * Shift to occupy the least-significant bits
    ADDQ.W  #1,D6               * Make it so that word = 1, long = 2

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     AddA,A1
    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.W  D3,D1               * Move the instruction back to D1

    MOVE.W  D1,D5               * D5 = The address register number
    ANDI.W  #$0E00,D5           * Isolate bits 11, 10, and 9
    LSR.W   #8,D5               * Shift to occupy the least-significant bits
    LSR.W   #1,D5

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address
    MOVE.L  D0,D4               * D4 = The effective address

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  #%11111111,D3
    BSR     DisplayEA           * Display the effective address source
    MOVE.B  D0,D2

    BSR     DisplayComma        * Display ','

    MOVE.B  D5,D1
    BSR     DisplayAddrDirect   * Display the address register destination

    MOVE.B  D0,D1
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseAddQ
* Description: Determines if an instruction word is an ADDQ instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an ADDQ, 0 otherwise.
*------------------------------------------------------------------------------
ParseAddQ
    BSR     IsAddQ
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayAddQ

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsAddQ
* Description: Determines if an instruction word is an ADDQ instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an ADDQ, 0 otherwise.
*------------------------------------------------------------------------------
IsAddQ
    MOVE.L  D2,-(SP)    * Preserve D2
    CLR.B   D0          * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2   * Isolate the first 4 bits
    CMPI.W  #$5000,D2   * If the opcode is not 0101 (5):
    BNE     .Return     *   The instruction is not ADDQ

    MOVE.W  D1,D2
    ANDI.W  #$0100,D2   * Isolate bit 8
    CMPI.W  #$0000,D2   * If bit is not 0:
    BNE     .Return     *   The instruction is not ADDQ

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2   * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2   * If the size is 3:
    BEQ     .Return     *   The instruction is not ADDQ

    MOVE.B  #1,D0       * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddQ
* Description: Displays an ADDQ instruction word.
* Parameters : D1.W = The ADDQ instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAddQ
    * D6.B = The instruction size
    * D5.B = The immediate data
    * D4.L = The effective address

.Registers  REG     D0-D6/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6, and A1

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    MOVE.W  D1,D3               * Store the instruction in D3 for now

    LEA     AddQ,A1
    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.W  D3,D1               * Move the instruction back to D1

    MOVE.W  D1,D5               * D5 = The immediate data
    ANDI.W  #$0E00,D5           * Isolate bits 11, 10, and 9
    LSR.W   #8,D5               * Shift to occupy the least-significant bits
    LSR.W   #1,D5

    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address
    MOVE.L  D0,D4               * D4 = The effective address

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  D5,D1
    BSR     DisplayImmediateByte    * Display the immediate data

    BSR     DisplayComma        * Display ','

    MOVE.B  #%01111101,D1       * Supported addressing modes if byte
    MOVE.B  #%01111111,D2       * Supported addressing modes if not byte
    MOVE.B  D6,D3
    BSR     SetSuppModesBySize  * Set the supported addressing modes

    MOVE.L  D4,D1
    MOVE.B  D6,D2
    MOVE.B  D0,D3
    BSR     DisplayEA           * Display the effective address source

    MOVE.B  #4,D1
    MOVE.B  D0,D2
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

    MOVEM.L (SP)+,.Registers    * Restore D0 to D6, and A1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
Add     DC.B    'ADD',0
AddA    DC.B    'ADDA',0
AddQ    DC.B    'ADDQ',0











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
