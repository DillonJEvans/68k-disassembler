*------------------------------------------------------------------------------
* Title      : IOUtilsTests
* Written by : Dillon Evans
* Date       : 5/30/23
* Description: Tests helpful IO utility subroutines.
*------------------------------------------------------------------------------
    ORG     $1000


*------------------------------------------------------------------------------
* Includes
*------------------------------------------------------------------------------
    INCLUDE ../src/IOUtils.X68


*------------------------------------------------------------------------------
* Start
*------------------------------------------------------------------------------
Start
    LEA     String,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask the user for a string

    LEA     UserInput,A1
    MOVE.B  #2,D0
    TRAP    #15                 * Accept a string from the user

    LEA     WaitTime,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask the user for a wait time

    MOVE.B  #4,D0
    TRAP    #15                 * Accept a wait time from the user

    LEA     PressEnter,A1
    MOVE.B  #13,D0
    TRAP    #15                 * Ask the user to press enter

    BSR     WaitForEnter        * Wait for the user to press enter

    LEA     UserInput,A1
    BSR     DisplayByLetter     * Display the string with the wait time

    BSR     NewLine
    BSR     NewLine
    BRA     Start               * Keep looping


*------------------------------------------------------------------------------
* Variables
*------------------------------------------------------------------------------
UserInput   DS.B    81  * Allocate space for user input to be stored


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
String      DC.B    'String: ',0
WaitTime    DC.B    'Wait Time: ',0
PressEnter  DC.B    'Press enter to display the string...',0


*------------------------------------------------------------------------------
* End
*------------------------------------------------------------------------------
    END     Start






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
