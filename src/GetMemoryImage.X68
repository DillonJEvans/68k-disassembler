*------------------------------------------------------------------------------
* Title      : GetMemoryImage
* Written by : Dillon Evans
* Date       : 6/2/23
* Description: Gets the memory image to disassemble.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : GetMemoryImage
* Description: Displays the welcome message and accepts the starting and ending
*              addresses of the program to disassemble (the memory image).
* Parameters : None.
* Returns    : A5 = The starting address of the memory image.
*              A6 = The ending address of the memory image.
*------------------------------------------------------------------------------
GetMemoryImage

.Registers  REG     D0-D1/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D1, and A1

    MOVE.L  #DefaultColor,D1
    BSR     SetTextColor        * Set the text color to default color

    LEA     WelcomeMsg,A1
    MOVE.L  #LetterWaitTime,D1
    BSR     DisplayByLetter     * Display the description letter-by-letter

    BSR     NewLine
    BSR     NewLine
    BSR     NewLine

.StartAddr
    BSR     ClearLine

    MOVE.L  #DefaultColor,D1
    BSR     SetTextColor        * Set the text color to default color

    LEA     StartAddrMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask for the starting address

    MOVE.L  #InputColor,D1
    BSR     SetTextColor        * Set the text color to input color

    LEA     UserInput,A1
    MOVE.B  #2,D0
    TRAP    #15                 * Accept the starting address

    BSR     HexToInt            * Convert the hex string to an address
    CMPI.B  #0,D1               * If the conversion failed:
    BLE     .InvalidStartAddr   *   Ask for a different starting address
    MOVEA.L D0,A5               * Store the starting address in A5

    BSR     NewLine

.EndAddr
    BSR     ClearLine

    MOVE.L  #DefaultColor,D1
    BSR     SetTextColor        * Set the text color to default color

    LEA     EndAddrMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask for the ending address

    MOVE.L  #InputColor,D1
    BSR     SetTextColor        * Set the text color to input color

    LEA     UserInput,A1
    MOVE.B  #2,D0
    TRAP    #15                 * Accept the ending address

    BSR     HexToInt            * Convert the hex string to an address
    CMPI.B  #0,D1               * If the conversion failed:
    BLE     .InvalidEndAddr     *   Ask for a different ending address
    CMPA.L  D0,A5               * If the ending address < starting address:
    BGT     .EndLTStart         *   Ask for a different ending address
    MOVEA.L D0,A6               * Store the ending address in A5

.Return
    BSR     NewLine
    BSR     ClearLine
    MOVE.W  #-1,D1
    BSR     OffsetRow           * Get rid of any lingering error message text

    MOVEM.L (SP)+,.Registers    * Restore D0, D1, and A1
    RTS                         * Return A5 and A6

.InvalidStartAddr
    BSR     .InvalidAddr
    BRA     .StartAddr

.InvalidEndAddr
    BSR     .InvalidAddr
    BRA     .EndAddr

.EndLTStart
    BSR     NewLine
    BSR     ClearLine

    MOVE.L  #InvalidInputColor,D1
    BSR     SetTextColor        * Set the text color to invalid input color

    LEA     EndLTStartMsg,A1
    MOVE.B  #13,D0
    TRAP    #15                 * Display an error message

    MOVE.W  #-3,D1
    BSR     OffsetRow           * Move the cursor to where it was before

    BRA     .EndAddr

* Nested subroutine
.InvalidAddr
    BSR     NewLine
    BSR     ClearLine

    MOVE.L  #InvalidInputColor,D1
    BSR     SetTextColor        * Set the text color to invalid input color

    MOVE.B  #'"',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display "

    LEA     UserInput,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Display the user's input

    MOVE.B  #'"',D1
    MOVE.B  #6,D0
    TRAP    #15                 * Display "

    LEA     InvalidAddrMsg,A1
    MOVE.B  #13,D0
    TRAP    #15                 * Display an error message

    MOVE.W  #-3,D1
    BSR     OffsetRow           * Move the cursor to where it was before

    RTS                         * Ask for another address


*------------------------------------------------------------------------------
* Variables
*------------------------------------------------------------------------------
UserInput   DS.B    81  * Allocate space for user input to be stored


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
WelcomeMsg
    DC.B    'WOOF WOOF! Welcome to Team Dog''s 68k Disassembler!',CR,LF
    DC.B    CR,LF
    DC.B    'This program disassembles a memory image of instructions',CR,LF
    DC.B    'and data back to the 68000 assembly language and outputs',CR,LF
    DC.B    'the disassembled code to the display.',CR,LF
    DC.B    CR,LF
    DC.B    'When entering where the memory image to disassemble is',CR,LF
    DC.B    'located, you must enter the starting and ending addresses',CR,LF
    DC.B    'of the memory image.',CR,LF
    DC.B    CR,LF
    DC.B    'These addresses must be entered in hexadecimal, and can be',CR,LF
    DC.B    'up to 32-bits long. If they are shorter than 32-bits, they',CR,LF
    DC.B    'will be extended with zeroes. For example, ABCD would become',CR,LF
    DC.B    '0000ABCD. Additionally, the ending address of the memory',CR,LF
    DC.B    'image must be greater than or equal to the starting address.',0

StartAddrMsg    DC.B    'Starting Address = $',0
EndAddrMsg      DC.B    'Ending Address = $',0
InvalidAddrMsg  DC.B    ' is not a valid address.',0
EndLTStartMsg   DC.B    'The ending address must be greater than or equal to '
                DC.B    'the starting address.',0,0


*------------------------------------------------------------------------------
* Equates
*------------------------------------------------------------------------------
LetterWaitTime  EQU     5
CR              EQU     $0D
LF              EQU     $0A










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
