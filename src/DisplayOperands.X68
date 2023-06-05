*------------------------------------------------------------------------------
* Title      : DisplayOperands
* Written by : Dillon Evans
* Date       : 5/24/23
* Description: Provides subroutines for displaying each kind of operand.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DisplayDataDirect
* Description: Displays a data register direct.
* Parameters : D1.B = The data register number.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayDataDirect
    MOVE.L  A1,-(SP)        * Preserve A1

    SUBQ.L  #4,SP
    MOVEA.L SP,A1           * Allocate 4 bytes for the operand string

    MOVE.B  #'D',(A1)       * Add 'D' to the string
    MOVE.B  D1,(1,A1)       * Add the data register number to the string
    ADDI.B  #'0',(1,A1)     * Convert the data register number to a char
    CLR.B   (2,A1)          * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15             * Display the operand string

    ADDQ.L  #4,SP           * Deallocate 4 bytes for the operand string
    MOVE.L  (SP)+,A1        * Restore A1
    MOVE.B  #2,D0           * Return 2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrDirect
* Description: Displays an address register direct.
* Parameters : D1.B = The address register number.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayAddrDirect
    MOVE.L  A1,-(SP)        * Preserve A1

    SUBQ.L  #4,SP
    MOVEA.L SP,A1           * Allocate 4 bytes for the operand string

    MOVE.B  #'A',(A1)       * Add 'A' to the string
    MOVE.B  D1,(1,A1)       * Add the address register number to the string
    ADDI.B  #'0',(1,A1)     * Convert the address register number to a char
    CLR.B   (2,A1)          * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15             * Display the operand string

    ADDQ.L  #4,SP           * Deallocate 4 bytes for the operand string
    MOVE.L  (SP)+,A1        * Restore A1
    MOVE.B  #2,D0           * Return 2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrIndirect
* Description: Displays an address register indirect.
* Parameters : D1.B = The address register number.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayAddrIndirect
    MOVE.L  A1,-(SP)        * Preserve A1

    SUBA.L  #8,SP
    MOVEA.L SP,A1           * Allocate 8 bytes for the operand string

    MOVE.W  #'(A',(A1)      * Add '(A' to the string
    MOVE.B  D1,(2,A1)       * Add the address register number to the string
    ADDI.B  #'0',(2,A1)     * Convert the address register number to a char
    MOVE.B  #')',(3,A1)     * Add ')' to the string
    CLR.B   (4,A1)          * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15             * Display the operand string

    ADDA.L  #8,SP           * Deallocate 8 bytes for the operand string
    MOVE.L  (SP)+,A1        * Restore A1
    MOVE.B  #4,D0           * Return 4
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrIncrement
* Description: Displays an address register indirect with post-increment.
* Parameters : D1.B = The address register number.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayAddrIncrement
    MOVE.L  A1,-(SP)        * Preserve A1

    SUBA.L  #8,SP
    MOVEA.L SP,A1           * Allocate 8 bytes for the operand string

    MOVE.W  #'(A',(A1)      * Add '(A' to the string
    MOVE.B  D1,(2,A1)       * Add the address register number to the string
    ADDI.B  #'0',(2,A1)     * Convert the address register number to a char
    MOVE.B  #')',(3,A1)     * Add ')' to the string
    MOVE.B  #'+',(4,A1)     * Add '+' to the string
    CLR.B   (5,A1)          * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15             * Display the operand string

    ADDA.L  #8,SP           * Deallocate 8 bytes for the operand string
    MOVE.L  (SP)+,A1        * Restore A1
    MOVE.B  #5,D0           * Return 5
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAddrDecrement
* Description: Displays an address register indirect with pre-decrement.
* Parameters : D1.B = The address register number.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayAddrDecrement
    MOVE.L  A1,-(SP)        * Preserve A1

    SUBA.L  #8,SP
    MOVEA.L SP,A1           * Allocate 8 bytes for the operand string

    MOVE.L  #'-(A ',(A1)    * Add '-(A' to the string
    MOVE.B  D1,(3,A1)       * Add the address register number to the string
    ADDI.B  #'0',(3,A1)     * Convert the address register number to a char
    MOVE.B  #')',(4,A1)     * Add ')' to the string
    CLR.B   (5,A1)          * Null terminate the string

    MOVE.B  #14,D0
    TRAP    #15             * Display the operand string

    ADDA.L  #8,SP           * Deallocate 8 bytes for the operand string
    MOVE.L  (SP)+,A1        * Restore A1
    MOVE.B  #5,D0           * Return 5
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAbsAddrWord
* Description: Displays an absolute address word.
* Parameters : D1.W = The absolute address.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayAbsAddrWord

.Registers  REG     D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D2 and A1

    SUBA.L  #8,SP
    MOVEA.L SP,A1               * Allocate 8 bytes for the operand string

    MOVE.B  #'$',(A1)+          * Add '$' to the string
    MOVE.B  #4,D2
    BSR     IntToHex            * Add the absolute address to the string
    SUBQ.L  #1,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    ADDA.L  #8,SP               * Deallocate 8 bytes for the operand string
    MOVEM.L (SP)+,.Registers    * Restore D2 and A1
    MOVE.B  #5,D0               * Return 5
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayAbsAddrLong
* Description: Displays an absolute address long.
* Parameters : D1.L = The absolute address.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayAbsAddrLong

.Registers  REG     D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D2 and A1

    SUBA.L  #12,SP
    MOVEA.L SP,A1               * Allocate 12 bytes for the operand string

    MOVE.B  #'$',(A1)+          * Add '$' to the string
    MOVE.B  #8,D2
    BSR     IntToHex            * Add the absolute address to the string
    SUBQ.L  #1,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    ADDA.L  #12,SP              * Deallocate 12 bytes for the operand string
    MOVEM.L (SP)+,.Registers    * Restore D2 and A1
    MOVE.B  #9,D0               * Return 9
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayImmediateByte
* Description: Displays an immediate data byte.
* Parameters : D1.B = The immediate data.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayImmediateByte

.Registers  REG     D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D2 and A1

    SUBA.L  #8,SP
    MOVEA.L SP,A1               * Allocate 8 bytes for the operand string

    MOVE.W  #'#$',(A1)+         * Add '#$' to the string
    MOVE.B  #2,D2
    BSR     IntToHex            * Add the immediate data to the string
    SUBQ.L  #2,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    ADDA.L  #8,SP               * Deallocate 8 bytes for the operand string
    MOVEM.L (SP)+,.Registers    * Restore D2 and A1
    MOVE.B  #4,D0               * Return 4
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayImmediateWord
* Description: Displays an immediate data word.
* Parameters : D1.W = The immediate data.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayImmediateWord

.Registers  REG     D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D2 and A1

    SUBA.L  #8,SP
    MOVEA.L SP,A1               * Allocate 8 bytes for the operand string

    MOVE.W  #'#$',(A1)+         * Add '#$' to the string
    MOVE.B  #4,D2
    BSR     IntToHex            * Add the immediate data to the string
    SUBQ.L  #2,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    ADDA.L  #8,SP               * Deallocate 8 bytes for the operand string
    MOVEM.L (SP)+,.Registers    * Restore D2 and A1
    MOVE.B  #6,D0               * Return 6
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayImmediateLong
* Description: Displays an immediate data long.
* Parameters : D1.L = The immediate data.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayImmediateLong

.Registers  REG     D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D2 and A1

    SUBA.L  #12,SP
    MOVEA.L SP,A1               * Allocate 12 bytes for the operand string

    MOVE.W  #'#$',(A1)+         * Add '#$' to the string
    MOVE.B  #8,D2
    BSR     IntToHex            * Add the immediate data to the string
    SUBQ.L  #2,A1

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    ADDA.L  #12,SP              * Deallocate 12 bytes for the operand string
    MOVEM.L (SP)+,.Registers    * Restore D2 and A1
    MOVE.B  #10,D0              * Return 10
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayUnidentified
* Description: Displays an unidentified effective address.
* Parameters : None.
* Returns    : D0.B = The length of the string displayed.
*------------------------------------------------------------------------------
DisplayUnidentified
    MOVE.L  A1,-(SP)            * Preserve A1

    SUBQ.L  #4,SP
    MOVEA.L SP,A1               * Allocate 4 bytes for the operand string

    MOVE.L  #$3F3F3F00,(A1)     * Set the string to '???'

    MOVE.B  #14,D0
    TRAP    #15                 * Display the operand string

    ADDQ.L  #4,SP               * Deallocate 4 bytes for the operand string
    MOVE.L  (SP)+,A1            * Restore A1
    MOVE.B  #3,D0               * Return 3
    RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
