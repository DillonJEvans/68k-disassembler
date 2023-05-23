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
    BSR     GetInstruction      * D3 = Instruction
    BSR     GetEA               * D4 = Effective Address
    BSR     GetMode             * D5 = Addressing Mode
    BSR     GetExtWords         * D6 = Extension Words

    BSR     NewLine

    BSR     DisplayEA           * Display the effective address
    BSR     DisplayMode         * Display the addressing mode
    BSR     DisplayExtWords     * Display the extension word count

    BSR     NewLine
    BSR     NewLine
    BRA     Start               * Keep looping


*------------------------------------------------------------------------------
* GetInstruction subroutine
*------------------------------------------------------------------------------
GetInstruction
    LEA     InstructionMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask for the instruction

    LEA     UserInput,A1
    MOVE.B  #2,D0
    TRAP    #15                 * Accept the instruction

    BSR     HexToInt            * Convert the instruction to an int
    CMPI.B  #4,D1               * If the string was not a word:
    BNE     .Invalid            *   Ask for a different instruction
    MOVE.W  D0,D3               * Store the instruction for later

    RTS

.Invalid
    LEA     InvalidMsg,A1
    MOVE.B  #13,D0
    TRAP    #15                 * Display an error message
    BSR     NewLine
    BRA     GetInstruction


*------------------------------------------------------------------------------
* GetEA subroutine
*------------------------------------------------------------------------------
GetEA
    LEA     EABitMsg,A1
    MOVE.B  #14,D0
    TRAP    #15             * Ask for the starting bit of the EA

    MOVE.B  #4,D0
    TRAP    #15             * Accept the starting bit of the EA

    MOVE.B  D1,D2
    MOVE.W  D3,D1
    BSR     ExtractEA       * Extract the EA from the instruction
    MOVE.L  D0,D4           * Store the EA for later

    RTS


*------------------------------------------------------------------------------
* GetMode subroutine
*------------------------------------------------------------------------------
GetMode
    MOVE.L  D4,D1
    BSR     GetAddressingMode   * Get the addressing mode of the EA
    CLR.L   D5
    MOVE.B  D0,D5               * Store the addressing mode for later

    RTS


*------------------------------------------------------------------------------
* GetExtWords subroutine
*------------------------------------------------------------------------------
GetExtWords
    LEA     SizeMsg,A1
    MOVE.B  #14,D0
    TRAP    #15             * Ask for the size of the instruction

    MOVE.B  #4,D0
    TRAP    #15             * Accept the size of the instruction

    MOVE.B  D1,D2
    MOVE.B  D5,D1
    BSR     CountExtWords   * Count the extension words needed for the EA
    CLR.L   D6
    MOVE.B  D0,D6           * Store the extension words count for later

    RTS


*------------------------------------------------------------------------------
* DisplayEA subroutine
*------------------------------------------------------------------------------
DisplayEA
    LEA     FirstMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Prepare to display the first part of the EA

    CLR.L   D1
    SWAP    D4
    MOVE.W  D4,D1
    MOVE.B  #3,D0
    TRAP    #15                 * Display the first part of the EA
    BSR     NewLine

    LEA     SecondMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Prepare to display the second part of the EA

    CLR.L   D1
    SWAP    D4
    MOVE.W  D4,D1
    MOVE.B  #3,D0
    TRAP    #15                 * Display the second part of the EA
    BSR     NewLine

    RTS


*------------------------------------------------------------------------------
* DisplayMode subroutine
*------------------------------------------------------------------------------
DisplayMode
    LEA     ModeMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Prepare to display the addressing mode

    MOVE.L  D5,D1
    MOVE.B  #3,D0
    TRAP    #15                 * Display the addressing mode
    BSR     NewLine

    RTS


*------------------------------------------------------------------------------
* DisplayExtWords subroutine
*------------------------------------------------------------------------------
DisplayExtWords
    LEA     ExtWordsMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Prepare to display the extension word count

    MOVE.L  D6,D1
    MOVE.B  #3,D0
    TRAP    #15                 * Display the extension word count
    BSR     NewLine

    RTS


*------------------------------------------------------------------------------
* Variables
*------------------------------------------------------------------------------
UserInput   DS.B    81  * Allocate space for user input to be stored


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
InstructionMsg  DC.B    'Instruction = $',0
EABitMsg        DC.B    'EA Starting Bit = ',0
SizeMsg         DC.B    'Size = ',0
FirstMsg        DC.B    'EA 1st = ',0
SecondMsg       DC.B    'EA 2nd = ',0
ModeMsg         DC.B    'Mode   = ',0
ExtWordsMsg     DC.B    'Words  = ',0
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
