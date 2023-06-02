*------------------------------------------------------------------------------
* Title      : ExtractBits
* Written by : Dillon Evans
* Date       : 5/31/23
* Description: 
*------------------------------------------------------------------------------


* This subroutine is probably useless, but I'll leave here it here just in case


*------------------------------------------------------------------------------
* Subroutine : ExtractBits
* Description: Extracts bits from a longword.
* Parameters : D1.L = The long to extract bits from.
*              D2.B = The most-significant bit to extract.
*              D3.B = The least-significant bit to extract.
* Returns    : D0.L = The extracted bits.
*------------------------------------------------------------------------------
ExtractBits
    MOVE.L  D4,-(SP)
    MOVE.L  D1,D0
    MOVEQ.L #31,D4
    SUB.B   D2,D4
    LSL.L   D4,D0
    ADD.L   D3,D4
    LSR.L   D4,D0
    MOVE.L  (SP)+,D4
    RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
