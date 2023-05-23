*------------------------------------------------------------------------------
* Title      : EATests
* Written by : Dillon Evans
* Date       : 5/23/23
* Description: Tests the subroutines for handling effective addresses.
*------------------------------------------------------------------------------
    ORG     $1000


*------------------------------------------------------------------------------
* Includes
*------------------------------------------------------------------------------
    INCLUDE ../src/EffectiveAddresses.X68
    INCLUDE ../src/HexToInt.X68
    INCLUDE ../src/IntToHex.X68
    INCLUDE ../src/NewLine.X68


*------------------------------------------------------------------------------
* Start
*------------------------------------------------------------------------------
Start
    LEA     InstructionMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask for the instruction

    LEA     UserInput,A1
    MOVE.B  #2,D0
    TRAP    #15                 * Accept the instruction

    BSR     HexToInt            * Convert the instruction to an int
    CMPI.B  #4,D1               * If the string was not a word:
    BNE     Invalid             *   Ask for a different instruction
    MOVE.W  D0,D3               * Store the instruction for later

    LEA     EABitMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask for the starting bit of the EA

    MOVE.B  #4,D0
    TRAP    #15                 * Accept the starting bit of the EA

    MOVE.B  D1,D2
    MOVE.W  D3,D1
    BSR     ExtractEA           * Extract the EA from the instruction
    MOVE.L  D0,D2               * Store the EA for later

    LEA     FirstMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Prepare to display the first part of the EA

    CLR.L   D1
    SWAP    D2
    MOVE.W  D2,D1
    MOVE.B  #3,D0
    TRAP    #15                 * Display the first part of the EA
    BSR     NewLine

    LEA     SecondMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Prepare to display the second part of the EA

    CLR.L   D1
    SWAP    D2
    MOVE.W  D2,D1
    MOVE.B  #3,D0
    TRAP    #15                 * Display the second part of the EA
    BSR     NewLine

    BSR     NewLine
    BRA     Start               * Keep looping

Invalid
    LEA     InvalidMsg,A1
    MOVE.B  #13,D0
    TRAP    #15                 * Display an error message
    BSR     NewLine
    BRA     Start


*------------------------------------------------------------------------------
* Variables
*------------------------------------------------------------------------------
UserInput   DS.B    81  * Allocate space for user input to be stored


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
InstructionMsg  DC.B    'Instruction = $',0
EABitMsg        DC.B    'EA Starting Bit = ',0
FirstMsg        DC.B    '1st = ',0
SecondMsg       DC.B    '2nd = ',0
InvalidMsg      DC.B    'That is not a valid instruction.',0


*------------------------------------------------------------------------------
* Equates
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* End
*------------------------------------------------------------------------------
    END     Start





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
