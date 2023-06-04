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
* When setting the colors, take note that most of the time colors are written
* in RGB-order, but here colors are in reverse (BGR-order).
*
* Default        = The default color of text
* Input          = User input
* InvalidInput   = Invalid input error messages
* Wait           = Wait messages, e.g. "Press enter to continue"
* Completion     = The completion message: "Disassembling complete"
* Address        = The address that an instruction is located at
* Instruction    = The instruction name, e.g. "ADD.B" or "SUB.L"
* DataLabel      = The stand-in for an instruction name for data: "DATA"
* Operand        = Operands, e.g. "D2" or "#$14"
* DataHex        = The value of data (non-instruction), e.g. "$1234"
* UnsupportedEA  = EAs that we can identify, but aren't supported by that
*                  specific instruction, e.g. "A1" for a NOT instruction
* UnidentifiedEA = EAs that we cannot identify as they aren't supported by the
*                  disassembler
* InvalidEA      = The message that an EA is not supported: "Unsupported EA"

                            *00BBGGRR
DefaultColor        EQU     $00FFFFFF   * White

InputColor          EQU     $00CCCCCC   * Light Grey
InvalidInputColor   EQU     $000000FF   * Red

WaitColor           EQU     $00FFFFFF   * White
CompletionColor     EQU     $0032CD32   * Lime Green

AddressColor        EQU     $00AAAAAA   * Dark Grey

InstructionColor    EQU     $00FFFFFF   * White
DataLabelColor      EQU     $00CCCCCC   * Light Grey

OperandColor        EQU     $00CCCCCC   * Light Grey
DataHexColor        EQU     $00CCCCCC   * Light Grey
UnsupportedEAColor  EQU     $000000FF   * Red
UnidentifiedEAColor EQU     $000000FF   * Red

InvalidEAColor      EQU     $000000FF   * Red






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
