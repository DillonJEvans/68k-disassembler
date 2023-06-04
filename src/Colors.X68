*------------------------------------------------------------------------------
* Title      : Colors
* Written by : Dillon Evans
* Date       : 6/3/23
* Description: Defines subroutines and equates for managing text color.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : SetTextColor
* Description: Sets the text color.
* Parameters : D1.L = The text color ($00BBGGRR).
* Returns    : None.
*------------------------------------------------------------------------------
SetTextColor

.Registers  REG     D0/D2

    MOVEM.L .Registers,-(SP)    * Preserve D0 and D2

    CLR.B   D2
    MOVE.B  #21,D0
    TRAP    #15                 * Set the text color

    MOVEM.L (SP)+,.Registers    * Restore D0 and D2
    RTS


*------------------------------------------------------------------------------
* Equates
*------------------------------------------------------------------------------
                            *00BBGGRR
AddressColor        EQU     $00AAAAAA   * Dark Grey
InstructionColor    EQU     $00FFFFFF   * White
OperandColor        EQU     $00CCCCCC   * Light Grey
UnsupportedColor    EQU     $000000FF   * Red





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~