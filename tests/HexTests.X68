*------------------------------------------------------------------------------
* Title      : HexTests
* Written by : Dillon Evans
* Date       : 5/20/23
* Description: Tests the HexToInt, IntToHex, and ExtractBits subroutines.
*------------------------------------------------------------------------------
    ORG     $1000


*------------------------------------------------------------------------------
* Includes
*------------------------------------------------------------------------------
    INCLUDE ../src/ExtractBits.X68
    INCLUDE ../src/HexToInt.X68
    INCLUDE ../src/IntToHex.X68
    INCLUDE ../src/IOUtils.X68


*------------------------------------------------------------------------------
* Start
*------------------------------------------------------------------------------
Start
    LEA     HexMsg,A1
    MOVE.B  #14,D0
    TRAP    #15             * Ask for the hex string

    LEA     UserInput,A1
    MOVE.B  #2,D0
    TRAP    #15             * Accept the hex string

    BSR     HexToInt        * Convert the hex string to an int
    CMPI.B  #0,D1           * If the conversion failed:
    BLT     Invalid         *   Ask for a different hex int
    MOVE.L  D0,D4           * Store the int for later

    LEA     MSBMsg,A1
    MOVE.B  #14,D0
    TRAP    #15             * Ask for the most-significant bit to extract

    MOVE.B  #4,D0
    TRAP    #15             * Accept the most-significant bit to extract
    MOVE.B  D1,D2           * Store the most-significant bit for later

    LEA     LSBMsg,A1
    MOVE.B  #14,D0
    TRAP    #15             * Ask for the least-significant bit to extract

    MOVE.B  #4,D0
    TRAP    #15             * Accept the least-significant bit to extract
    MOVE.B  D1,D3           * Store the least-significant bit for later

    MOVE.L  D4,D1
    BSR     ExtractBits     * Extract the bits

    MOVE.L  D0,D1
    SUB.B   D3,D2
    LSR.B   #2,D2
    ADDQ.B  #1,D2
    LEA     BitsOutput,A1
    BSR     IntToHex        * Convert the extracted bits to a hex string

    LEA     BitsMsg,A1
    MOVE.B  #14,D0
    TRAP    #15             * Prepare to display the extracted bits string

    LEA     BitsOutput,A1
    MOVE.B  #13,D0
    TRAP    #15             * Display the extracted bits string

    BSR     NewLine
    BRA     Start           * Keep looping

Invalid
    LEA     InvalidMsg,A1
    MOVE.B  #13,D0
    TRAP    #15             * Display an error message
    BSR     NewLine
    BRA     Start


*------------------------------------------------------------------------------
* Variables
*------------------------------------------------------------------------------
UserInput   DS.B    81  * Allocate space for user input to be stored
BitsOutput  DS.B    9   * Allocate space for extracted bits output to be stored


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
HexMsg      DC.B    'Hex = $',0
BitsMsg     DC.B    'Extracted Bits = $',0
MSBMsg      DC.B    'MSB = ',0
LSBMsg      DC.B    'LSB = ',0
InvalidMsg  DC.B    'That is not a valid hexadecial number.',0


*------------------------------------------------------------------------------
* End
*------------------------------------------------------------------------------
    END     Start









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
