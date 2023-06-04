*------------------------------------------------------------------------------
* Title      : DisplayOperands
* Written by : Dillon Evans
* Date       : 5/24/23
* Description: 
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DisplayDataDirect
* Description: Displays a data register direct.
* Parameters : D1.B = The data register number.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayDataDirect

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The data register number

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.L  D2,D1
    LEA     (-4,SP),A1          * Allocate 4 bytes for the operand string

    MOVE.B  #'D',(A1)           * Add 'D' to the string
    ADDI.B  #'0',D2             * Convert the data register number to a char
    MOVE.B  D2,(1,A1)           * Add the data register number to the string
    CLR.B   (2,A1)              * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrDirect
* Description: Displays an address register direct.
* Parameters : D1.B = The address register number.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAddrDirect

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The address register number

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.L  D2,D1
    LEA     (-4,SP),A1          * Allocate 4 bytes for the operand string

    MOVE.B  #'A',(A1)           * Add 'A' to the string
    ADDI.B  #'0',D2             * Convert the address register number to a char
    MOVE.B  D2,(1,A1)           * Add the address register number to the string
    CLR.B   (2,A1)              * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrIndirect
* Description: Displays an address register indirect.
* Parameters : D1.B = The address register number.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAddrIndirect

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The address register number

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.L  D2,D1
    LEA     (-8,SP),A1          * Allocate 8 bytes for the operand string

    MOVE.W  #'(A',(A1)          * Add '(A' to the string
    ADDI.B  #'0',D2             * Convert the address register number to a char
    MOVE.B  D2,(2,A1)           * Add the address register number to the string
    MOVE.B  #')',(3,A1)         * Add ')' to the string
    CLR.B   (4,A1)              * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrIncrement
* Description: Displays an address register indirect with post-increment.
* Parameters : D1.B = The address register number.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAddrIncrement

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The address register number

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.L  D2,D1
    LEA     (-8,SP),A1          * Allocate 8 bytes for the operand string

    MOVE.W  #'(A',(A1)          * Add '(A' to the string
    ADDI.B  #'0',D2             * Convert the address register number to a char
    MOVE.B  D2,(2,A1)           * Add the address register number to the string
    MOVE.B  #')',(3,A1)         * Add ')' to the string
    MOVE.B  #'+',(4,A1)         * Add '+' to the string
    CLR.B   (5,A1)              * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrDecrement
* Description: Displays an address register indirect with pre-decrement.
* Parameters : D1.B = The address register number.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAddrDecrement

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The address register number

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.L  D2,D1
    LEA     (-8,SP),A1          * Allocate 8 bytes for the operand string

    MOVE.L  #'-(A ',(A1)        * Add '-(A' to the string
    ADDI.B  #'0',D2             * Convert the address register number to a char
    MOVE.B  D2,(3,A1)           * Add the address register number to the string
    MOVE.B  #')',(4,A1)         * Add ')' to the string
    CLR.B   (5,A1)              * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAbsAddrWord
* Description: Displays an absolute address word.
* Parameters : D1.W = The absolute address.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAbsAddrWord

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The absolute address

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    LEA     (-8,SP),A1          * Allocate 8 bytes for the operand string

    MOVE.B  #'$',(A1)+          * Add '$' to the string
    MOVE.L  D2,D1
    MOVE.B  #4,D2
    BSR     IntToHex            * Add the absolute address to the string
    SUBQ.L  #1,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAbsAddrLong
* Description: Displays an absolute address long.
* Parameters : D1.L = The absolute address.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayAbsAddrLong

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The absolute address

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    LEA     (-12,SP),A1         * Allocate 12 bytes for the operand string

    MOVE.B  #'$',(A1)+          * Add '$' to the string
    MOVE.L  D2,D1
    MOVE.B  #8,D2
    BSR     IntToHex            * Add the absolute address to the string
    SUBQ.L  #1,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayImmediateByte
* Description: Displays an immediate data byte.
* Parameters : D1.B = The immediate data.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayImmediateByte

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The immediate data

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    LEA     (-8,SP),A1          * Allocate 8 bytes for the operand string

    MOVE.W  #'#$',(A1)+         * Add '#$' to the string
    MOVE.L  D2,D1
    MOVE.B  #2,D2
    BSR     IntToHex            * Add the immediate data to the string
    SUBQ.L  #2,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayImmediateWord
* Description: Displays an immediate data word.
* Parameters : D1.W = The immediate data.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayImmediateWord

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The immediate data

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    LEA     (-8,SP),A1          * Allocate 8 bytes for the operand string

    MOVE.W  #'#$',(A1)+         * Add '#$' to the string
    MOVE.L  D2,D1
    MOVE.B  #4,D2
    BSR     IntToHex            * Add the immediate data to the string
    SUBQ.L  #2,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayImmediateLong
* Description: Displays an immediate data long.
* Parameters : D1.L = The immediate data.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayImmediateLong

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The immediate data

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    LEA     (-12,SP),A1         * Allocate 12 bytes for the operand string

    MOVE.W  #'#$',(A1)+         * Add '#$' to the string
    MOVE.L  D2,D1
    MOVE.B  #8,D2
    BSR     IntToHex            * Add the immediate data to the string
    SUBQ.L  #2,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayUnsupported
* Description: Display an unsupported effective address.
* Parameters : None.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayUnsupported

.Registers  REG     D0-D1/A1

    MOVEM.L .Registers,-(SP)        * Preserve D0, D1, and A1

    MOVE.L  #UnsupportedColor,D1
    BSR     SetTextColor            * Set the text color to unsupported color

    LEA     (-4,SP),A1              * Allocate 4 bytes for the operand string

    MOVE.L  #$3F3F3F00,(A1)         * Set the string to '???'

    MOVE.B  #14,D0
    TRAP    #15                     * Display the operand string

    MOVEM.L (SP)+,.Registers        * Restore D0, D1, and A1
    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
