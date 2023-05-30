*------------------------------------------------------------------------------
* Title      : IOUtils
* Written by : Dillon Evans
* Date       : 5/25/23
* Description: Provides a variety of helpful IO utility subroutines.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : DisplayByLetter
* Description: Displays a string letter-by-letter. If the user presses a key,
*              this subroutine will be interrupted and the remainder of the
*              string will be displayed immediately.
* Parameters : (A1) = The null-terminated string to display.
*              D1.L = How many hundreths of a second to wait between letters.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayByLetter

.Registers  REG     D0/D2/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, and A1
    MOVE.L  D1,D2               * D2 = The time wait between letters

.Loop
    MOVE.B  #7,D0
    TRAP    #15                 * Check if keyboard input in pending
    CMPI.B  #1,D1               * If keyboard is pending:
    BEQ     .Interrupt          *   Display the rest of the string and return

    MOVE.B  (A1)+,D1            * Read the next character into D1
    CMPI.B  #0,D1               * If the end of the string has been reached:
    BEQ     .Return             *   Return

    MOVE.B  #6,D0
    TRAP    #15                 * Display the next character

    MOVE.L  D2,D1
    MOVE.B  #23,D0
    TRAP    #15                 * Wait some time between characters

    BRA     .Loop               * Keep looping

.Interrupt
    MOVE.B  #0,D1
    MOVE.B  #12,D0
    TRAP    #15                 * Disable echo
    MOVE.B  #5,D0
    TRAP    #15                 * Consume the character pending
    MOVE.B  #1,D1
    MOVE.B  #12,D0
    TRAP    #15                 * Enable echo
    MOVE.B  #14,D0
    TRAP    #15                 * Display the rest of the string

.Return
    MOVE.L  D2,D1               * Move the time to wait between letters back
                                *   to it's original register
    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : NewLine
* Description: Displays a new line (carriage return and line feed characters).
* Parameters : None.
* Returns    : None.
*------------------------------------------------------------------------------
NewLine

.Registers  REG     D0/A1

    MOVEM.L .Registers,-(SP)    * Preserve D0 and A1
    LEA     CRLF,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Display the new line characters
    MOVEM.L (SP)+,.Registers    * Restore D0 and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : WaitForEnter
* Description: Waits for the user to press enter.
* Parameters : None.
* Returns    : None.
*------------------------------------------------------------------------------
WaitForEnter

.Registers  REG     D0-D1

    MOVEM.L .Registers,-(SP)    * Preserve D0 and D1

    MOVE.B  #0,D1
    MOVE.B  #12,D0
    TRAP    #15                 * Disable echo

.ReadChar
    MOVE.B  #5,D0
    TRAP    #15                 * Accept a character from the user
    CMPI.B  #$0D,D1             * If the char isn't a newline character
    BNE     .ReadChar           * Keep waiting

    MOVE.B  #1,D1
    MOVE.B  #12,D0
    TRAP    #15                 * Enable echo

    MOVEM.L (SP)+,.Registers    * Restore D0 and D1
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
CRLF    DC.B    $0D,$0A,0,0     * New line characters





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
