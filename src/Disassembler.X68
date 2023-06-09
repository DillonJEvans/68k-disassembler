*------------------------------------------------------------------------------
* Title      : Disassembler
* Written by : Dillon Evans
* Date       : 5/25/23
* Description: Disassembles a memory image to 68000 assembly.
*------------------------------------------------------------------------------
    INCLUDE ../tests/demo_test.X68  * Demo code between $9000 and $93C0


    ORG     $1000


*------------------------------------------------------------------------------
* Includes
*------------------------------------------------------------------------------
    INCLUDE Colors.X68
    INCLUDE DisplayInstruction.X68
    INCLUDE DisplayMisc.X68
    INCLUDE DisplayOperands.X68
    INCLUDE EffectiveAddresses.X68
    INCLUDE GetMemoryImage.X68
    INCLUDE HexToInt.X68
    INCLUDE IntToHex.X68
    INCLUDE IOUtils.X68
    INCLUDE ParseUtils.X68

    INCLUDE ParseAddFamily.X68
    INCLUDE ParseBraFamily.X68
    INCLUDE ParseLogicFamily.X68
    INCLUDE ParseMoveFamily.X68
    INCLUDE ParseShiftFamily.X68
    INCLUDE ParseSub.X68
    INCLUDE ParseMisc.X68


*------------------------------------------------------------------------------
* Start
*------------------------------------------------------------------------------
Start
    BSR     ClearScreen
    BSR     GetMemoryImage      * Gets the memory image from the user

    MOVE.B  #25,D7              * D7 = The displayed instructions count

.Loop
    CMPA.L  A6,A5               * If the end address has been passed:
    BGT     .End                *   Halt the simulator

    CMPI.B  #25,D7              * If the screen is full:
    BEQ     .FullScreen         *   Handle a full screen
    BRA     .LoopBody           * Else:
                                *   Loop like normal

.FullScreen
    BSR     NewLine

    MOVE.L  #WaitColor,D1
    BSR     SetTextColor        * Set the text color to wait color

    LEA     PressEnterMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Ask the user to press enter

    BSR     WaitForEnter        * Wait for the user to press enter
    BSR     ClearScreen         * Clear the screen
    CLR.B   D7                  * Set the displayed instructions count to zero

.LoopBody
    MOVE.L  A5,D1
    BSR     DisplayAddress      * Display the current address

    MOVE.W  (A5)+,D1            * Read the next instruction word
    BSR     DisplayInstruction  * Display the instruction

    BSR     NewLine
    ADDQ.B  #1,D7               * Increment the displayed instructions count
    BRA     .Loop               * Keep looping

.End
    BSR     NewLine

    MOVE.L  #CompletionColor,D1
    BSR     SetTextColor        * Set the text color to completion color

    LEA     CompleteMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Display a complete message

    BSR     NewLine

    MOVE.L  #WaitColor,D1
    BSR     SetTextColor        * Set the text color to wait color

    LEA     RestartMsg,A1
    MOVE.B  #14,D0
    TRAP    #15                 * Display a restart message

    BSR     WaitForYN           * Accept either a Y or N from the user

    CMPI.B  #1,D0               * If y was entered:
    BEQ     Start               *   Restart the disassembler

    MOVE.B  #9,D0
    TRAP    #15                 * Halt the simulator


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
PressEnterMsg   DC.B    'Please press enter to continue...',0
CompleteMsg     DC.B    'Disassembling complete.',0
RestartMsg      DC.B    'Restart disassembler? (Y/N) ',0


*------------------------------------------------------------------------------
* End
*------------------------------------------------------------------------------
    END     Start























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
