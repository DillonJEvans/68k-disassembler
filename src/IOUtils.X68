*------------------------------------------------------------------------------
* Title      : IOUtils
* Written by : Dillon Evans
* Date       : 5/25/23
* Description: Provides a variety of helpful IO utility subroutines.
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ClearLine
* Description: Clears the current line.
* Parameters : None.
* Returns    : None.
*------------------------------------------------------------------------------
ClearLine

.Registers  REG     D0-D3

    MOVEM.L .Registers,-(SP)    * Preserve D0, D1, D2, and D3

    MOVE.W  #$00FF,D1
    MOVE.B  #11,D0
    TRAP    #15                 * Get the current cursor position
    MOVE.W  D1,D3               * Save the cursor position for later

    CLR.B   D2                  * D2 = The counter
    MOVE.B  #' ',D1
    MOVE.B  #6,D0               * Prepare TRAP to display a space

.Loop
    CMPI.B  #128,D2             * If D2 == 128:
    BEQ     .Return             *   Return

    TRAP    #15                 * Display a space

    ADDQ.B  #1,D2               * D2++
    BRA     .Loop               * Keep looping

.Return
    MOVE.W  D3,D1
    MOVE.B  #11,D0
    TRAP    #15                 * Move the cursor back to where it started

    MOVEM.L (SP)+,.Registers    * Restore D0, D1, D2, and D3
    RTS


*------------------------------------------------------------------------------
* Subroutine : ClearScreen
* Description: Clears the screen.
* Parameters : None.
* Returns    : None.
*------------------------------------------------------------------------------
ClearScreen

.Registers  REG     D0-D1

    MOVEM.L .Registers,-(SP)    * Preserve D0 and D1

    MOVE.W  #$FF00,D1
    MOVE.B  #11,D0
    TRAP    #15                 * Clear the screen

    MOVEM.L (SP)+,.Registers    * Restore D0 and D1
    RTS


*------------------------------------------------------------------------------
* Subroutine : ConsumePendingInput
* Description: Consumes any pending keyboard input.
* Parameters : None.
* Returns    : None.
* Notes:
*   I believe only one key can be pending at a time, but I wasn't sure about
*   this, so this subroutines loops until there is no more pending input.
*------------------------------------------------------------------------------
ConsumePendingInput

.Registers  REG     D0-D1

    MOVEM.L .Registers,-(SP)    * Preserve D0 and D1

    MOVE.B  #0,D1
    MOVE.B  #12,D0
    TRAP    #15                 * Disable echo

.ConsumeChar
    MOVE.B  #7,D0
    TRAP    #15                 * Check if keyboard input is pending
    CMPI.B  #0,D1               * If no keyboard input is pending:
    BEQ     .Return             *   Return

    MOVE.B  #5,D0
    TRAP    #15                 * Consume a character of pending keyboard input

    BRA     .ConsumeChar        * Keep looping

.Return
    MOVE.B  #1,D1
    MOVE.B  #12,D0
    TRAP    #15                 * Enable echo

    MOVEM.L (SP)+,.Registers    * Restore D0 and D1
    RTS


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
    BSR     ConsumePendingInput * Consume the pending input
    MOVE.B  #14,D0
    TRAP    #15                 * Display the rest of the string

.Return
    MOVE.L  D2,D1               * Move the time to wait between letters back
                                *   to it's original register
    MOVEM.L (SP)+,.Registers    * Restore D0, D2, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayByLine
* Description: Displays a string line-by-line. If the user presses a key, this
*              subroutine will be interrupted and the remainder of the string
*              will be displayed immediately.
* Parameters : (A1) = The null-terminated string to display.
*              D1.L = How many hundreths of a second to wait between lines.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayByLine

.Registers  REG     D0/D2/A0-A1
.CR         EQU     $0D

    MOVEM.L .Registers,-(SP)    * Preserve D0, D2, A0, and A1
    MOVE.L  D1,D2               * D2 = The time wait between letters

.Loop
    MOVE.B  #7,D0
    TRAP    #15                 * Check if keyboard input in pending
    CMPI.B  #1,D1               * If keyboard is pending:
    BEQ     .Interrupt          *   Display the rest of the string and return

    MOVEA.L A1,A0               * A0 = Current character

.FindNextLine
    MOVE.B  (A0)+,D1
    CMPI.B  #0,D1               * If the end of the string has been reached:
    BEQ     .Interrupt          *   Display and return

    CMPI.B  #.CR,D1             * If the end of the line has been reached:
    BEQ     .LoopEnd            *   Display the line

    BRA     .FindNextLine       * Keep looping

.LoopEnd
    MOVE.B  #0,-(A0)            * Replace the CR with a null terminator

    MOVE.B  #13,D0
    TRAP    #15                 * Display the line

    MOVE.B  #.CR,(A0)           * Put the CR back where it was
    LEA     (2,A0),A1           * Skip past the newline characters

    MOVE.L  D2,D1
    MOVE.B  #23,D0
    TRAP    #15                 * Wait some time between characters

    BRA     .Loop               * Keep looping

.Interrupt
    BSR     ConsumePendingInput * Consume the pending input
    MOVE.B  #14,D0
    TRAP    #15                 * Display the rest of the string

.Return
    MOVE.L  D2,D1               * Move the time to wait between letters back
                                *   to it's original register
    MOVEM.L (SP)+,.Registers    * Restore D0, D2, A0, and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : NewLine
* Description: Displays a new line (carriage return and line feed characters).
* Parameters : None.
* Returns    : None.
*------------------------------------------------------------------------------
NewLine

.Registers  REG     D0/A1
.CRLF       DC.B    $0D,$0A,0   * New line characters

    MOVEM.L .Registers,-(SP)    * Preserve D0 and A1

    LEA     .CRLF,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Display the new line characters

    MOVEM.L (SP)+,.Registers    * Restore D0 and A1
    RTS


*------------------------------------------------------------------------------
* Subroutine : OffsetRow
* Description: Moves the cursor to it's current row plus the given offset.
* Parameters : D1.W = The row offset (-128 to 128).
* Returns    : None.
*------------------------------------------------------------------------------
OffsetRow

.Registers  REG     D0/D2

    MOVEM.L .Registers,-(SP)    * Preserve D0 and D2
    MOVE.L  D1,D2               * D2 = The offset

    MOVE.W  #$00FF,D1
    MOVE.B  #11,D0
    TRAP    #15                 * Get the current cursor position
    ADD.L   D2,D1               * Add the offset
    TRAP    #15                 * Move the cursor to the new position

    MOVEM.L (SP)+,.Registers    * Restore D0 and D2
    RTS


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





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
