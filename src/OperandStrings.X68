*------------------------------------------------------------------------------
* Title      : OperandStrings
* Written by : Dillon Evans
* Date       : 5/24/23
* Description: 
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DataDirectToString
* Description: Converts a data register direct to a string.
* Parameters : D1.B = The data register number.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
DataDirectToString
    MOVE.B  #'D',(A1)
    MOVE.B  D1,(1,A1)
    ADDI.B  #'0',(1,A1)
    CLR.B   (2,A1)
    RTS


*------------------------------------------------------------------------------
* Subroutine : AddrDirectToString
* Description: Converts an address register direct to a string.
* Parameters : D1.B = The address register number.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
AddrDirectToString
    MOVE.B  #'A',(A1)
    MOVE.B  D1,(1,A1)
    ADDI.B  #'0',(1,A1)
    CLR.B   (2,A1)
    RTS


*------------------------------------------------------------------------------
* Subroutine : AddrIndirectToString
* Description: Converts an address register indirect to a string.
* Parameters : D1.B = The address register number.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
AddrIndirectToString
    MOVE.W  #'(A',(A1)
    MOVE.B  D1,(2,A1)
    ADDI.B  #'0',(2,A1)
    MOVE.B  #')',(3,A1)
    CLR.B   (4,A1)
    RTS


*------------------------------------------------------------------------------
* Subroutine : AddrIncrementToString
* Description: Converts an address register indirect with post-increment to a
*              string.
* Parameters : D1.B = The address register number.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
AddrIncrementToString
    MOVE.W  #'(A',(A1)
    MOVE.B  D1,(2,A1)
    ADDI.B  #'0',(2,A1)
    MOVE.W  #')+',(3,A1)
    CLR.B   (5,A1)
    RTS


*------------------------------------------------------------------------------
* Subroutine : AddrDecrementToString
* Description: Converts an address register indirect with pre-decrement to a
*              string.
* Parameters : D1.B = The address register number.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
AddrDecrementToString
    MOVE.L  #'-(A',(A1)
    MOVE.B  D1,(3,A1)
    ADDI.B  #'0',(3,A1)
    MOVE.B  #')',(4,A1)
    CLR.B   (5,A1)
    RTS


*------------------------------------------------------------------------------
* Subroutine : AbsAddrWordToString
* Description: Converts an absolute address word to a string.
* Parameters : D1.W = The absolute address.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
AbsAddrWordToString
    MOVE.L  D2,-(SP)
    MOVE.B  #'$',(A1)+
    MOVE.B  #4,D2
    BSR     IntToHex
    SUBQ.L  #1,A1
    MOVE.L  (SP)+,D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : AbsAddrLongToString
* Description: Converts an absolute address long to a string.
* Parameters : D1.L = The absolute address.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
AbsAddrLongToString
    MOVE.L  D2,-(SP)
    MOVE.B  #'$',(A1)+
    MOVE.B  #8,D2
    BSR     IntToHex
    SUBQ.L  #1,A1
    MOVE.L  (SP)+,D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : ImmediateByteToString
* Description: Converts an immediate data byte to a string.
* Parameters : D1.B = The immediate data.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
ImmediateByteToString
    MOVE.L  D2,-(SP)
    MOVE.W  #'#$',(A1)+
    MOVE.B  #2,D2
    BSR     IntToHex
    SUBQ.L  #2,A1
    MOVE.L  (SP)+,D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : ImmediateWordToString
* Description: Converts an immediate data word to a string.
* Parameters : D1.W = The immediate data.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
ImmediateWordToString
    MOVE.L  D2,-(SP)
    MOVE.W  #'#$',(A1)+
    MOVE.B  #4,D2
    BSR     IntToHex
    SUBQ.L  #2,A1
    MOVE.L  (SP)+,D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : ImmediateLongToString
* Description: Converts an immediate data long to a string.
* Parameters : D1.L = The immediate data.
*               A1  = The location to store the string at.
* Returns    : (A1) = The null-terminated string.
*------------------------------------------------------------------------------
ImmediateLongToString
    MOVE.L  D2,-(SP)
    MOVE.W  #'#$',(A1)+
    MOVE.B  #8,D2
    BSR     IntToHex
    SUBQ.L  #2,A1
    MOVE.L  (SP)+,D2
    RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
