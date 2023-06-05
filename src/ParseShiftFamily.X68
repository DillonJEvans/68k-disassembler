*------------------------------------------------------------------------------
* Title      : ParseShiftFamily
* Written by : Dillon Evans
* Date       : 6/5/23
* Description: Parses and displays the following instructions:
*              ASL, ASR, LSL, LSR, ROL, ROR
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
* Subroutine : ParseASd
* Description: Determines if an instruction word is an ASL/ASR instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was an ASL/ASR, 0 otherwise.
*------------------------------------------------------------------------------
ParseASd
    BSR     IsASd
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayASd

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsASd
* Description: Determines if an instruction word is an ASL/ASR instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is an ASL/ASR, 0 otherwise.
*------------------------------------------------------------------------------
IsASd
    MOVE.L  D2,-(SP)        * Preserve D2
    CLR.B   D0              * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2       * Isolate the first 4 bits
    CMPI.W  #$E000,D2       * If the opcode is not 1110 (E):
    BNE     .Return         *   The instruction is not ASL/ASR

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2       * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2       * If the size is 3:
    BEQ     .MemoryShift    *   The instruction may be a memory shift
                            * Else:
                            *   The instruction may be a register shift

.RegisterShift
    MOVE.W  D1,D2
    ANDI.W  #$0018,D2       * Isolate bits 4 and 3
    CMPI.W  #$0000,D2       * If the bits are not 00:
    BNE     .Return         *   The instruction is not ASL/ASR
    MOVE.B  #1,D0           * Set the return value to 1
    BRA     .Return

.MemoryShift
    MOVE.W  D1,D2
    ANDI.W  #$0E00,D2       * Isolate bits 11, 10, and 9
    CMPI.W  #$0000,D2       * If the bits are not 000 (0):
    BNE     .Return         *   The instruction is not ASL/ASR
    MOVE.B  #1,D0           * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayASd
* Description: Displays a ASL/ASR instruction word.
* Parameters : D1.W = The ASL/ASR instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayASd
    LEA     ASd,A1
    BSR     DisplayShift
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseLSd
* Description: Determines if an instruction word is a LSL/LSR instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a LSL/LSR, 0 otherwise.
*------------------------------------------------------------------------------
ParseLSd
    BSR     IsLSd
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayLSd

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsLSd
* Description: Determines if an instruction word is a LSL/LSR instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a LSL/LSR, 0 otherwise.
*------------------------------------------------------------------------------
IsLSd
    MOVE.L  D2,-(SP)        * Preserve D2
    CLR.B   D0              * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2       * Isolate the first 4 bits
    CMPI.W  #$E000,D2       * If the opcode is not 1110 (E):
    BNE     .Return         *   The instruction is not LSL/LSR

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2       * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2       * If the size is 3:
    BEQ     .MemoryShift    *   The instruction may be a memory shift
                            * Else:
                            *   The instruction may be a register shift

.RegisterShift
    MOVE.W  D1,D2
    ANDI.W  #$0018,D2       * Isolate bits 4 and 3
    CMPI.W  #$0008,D2       * If the bits are not 01:
    BNE     .Return         *   The instruction is not LSL/LSR
    MOVE.B  #1,D0           * Set the return value to 1
    BRA     .Return

.MemoryShift
    MOVE.W  D1,D2
    ANDI.W  #$0E00,D2       * Isolate bits 11, 10, and 9
    CMPI.W  #$0200,D2       * If the bits are not 001 (1):
    BNE     .Return         *   The instruction is not LSL/LSR
    MOVE.B  #1,D0           * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayLSd
* Description: Displays a LSL/LSR instruction word.
* Parameters : D1.W = The LSL/LSR instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayLSd
    LEA     LSd,A1
    BSR     DisplayShift
    RTS


*------------------------------------------------------------------------------
* Subroutine : ParseROd
* Description: Determines if an instruction word is a ROL/ROR instruction,
*              and if so, displays it.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction was a ROL/ROR, 0 otherwise.
*------------------------------------------------------------------------------
ParseROd
    BSR     IsROd
    CMPI.B  #0,D0
    BEQ     .Return
    BSR     DisplayROd

.Return
    RTS


*------------------------------------------------------------------------------
* Subroutine : IsROd
* Description: Determines if an instruction word is a ROL/ROR instruction.
* Parameters : D1.W = The instruction word.
* Returns    : D0.B = 1 if the instruction word is a ROL/ROR, 0 otherwise.
*------------------------------------------------------------------------------
IsROd
    MOVE.L  D2,-(SP)        * Preserve D2
    CLR.B   D0              * Set the return value to 0

    MOVE.W  D1,D2
    ANDI.W  #$F000,D2       * Isolate the first 4 bits
    CMPI.W  #$E000,D2       * If the opcode is not 1110 (E):
    BNE     .Return         *   The instruction is not ROL/ROR

    MOVE.W  D1,D2
    ANDI.W  #$00C0,D2       * Isolate bits 7 and 6
    CMPI.W  #$00C0,D2       * If the size is 3:
    BEQ     .MemoryShift    *   The instruction may be a memory shift
                            * Else:
                            *   The instruction may be a register shift

.RegisterShift
    MOVE.W  D1,D2
    ANDI.W  #$0018,D2       * Isolate bits 4 and 3
    CMPI.W  #$0018,D2       * If the bits are not 11:
    BNE     .Return         *   The instruction is not ROL/ROR
    MOVE.B  #1,D0           * Set the return value to 1
    BRA     .Return

.MemoryShift
    MOVE.W  D1,D2
    ANDI.W  #$0E00,D2       * Isolate bits 11, 10, and 9
    CMPI.W  #$0600,D2       * If the bits are not 011 (2):
    BNE     .Return         *   The instruction is not ROL/ROR
    MOVE.B  #1,D0           * Set the return value to 1

.Return
    MOVE.L  (SP)+,D2    * Restore D2
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayROd
* Description: Displays a ROL/ROR instruction word.
* Parameters : D1.W = The ROL/ROR instruction word.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayROd
    LEA     ROd,A1
    BSR     DisplayShift
    RTS


*------------------------------------------------------------------------------
* Subroutine : DisplayShift
* Description: Displays a shift instruction word.
* Parameters : D1.W = The shift instruction word.
*              (A1) = The double null terminated instruction name.
* Returns    : None.
*------------------------------------------------------------------------------
DisplayShift
    * D6.B = The instruction size

.Registers  REG     D0-D6

    MOVEM.L .Registers,-(SP)    * Preserve D0 to D6
    MOVE.W  D1,D3               * Store the instruction in D3 for later

    MOVE.W  D1,D6               * D6 = The instruction size
    ANDI.W  #$00C0,D6           * Isolate bits 7 and 6
    LSR.W   #6,D6               * Shift to occupy the least-significant bits

    BTST.L  #8,D1               * If the direction is 0:
    BEQ     .RightShift         *   Shift right
                                * Else:
                                *   Shift left

.LeftShift
    MOVE.B  #'L',(2,A1)         * Replace the first of 2 null terminators
    BRA     .BranchSize

.RightShift
    MOVE.B  #'R',(2,A1)         * Replace the first of 2 null terminators

.BranchSize
    CMPI.B  #3,D6               * If the size is 3:
    BEQ     .MemoryShift        *   Memory shift
                                * Else:
                                *   Register shift

.RegisterShift
    * D5.B = The data register number
    * D4.B = The count or source data register number

    MOVE.B  D6,D1
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.B  D3,D5               * D5 = The data register number
    ANDI.B  #$07,D5             * Isolate bits 2, 1, and 0

    MOVE.W  D3,D4               * D4 = The count or source data register number
    ANDI.W  #$0E00,D4           * Isolate bits 11, 10, and 9
    LSR.W   #8,D4               * Shift to occupy the least-significant bits
    LSR.W   #1,D4

    MOVE.L  #OperandColor,D1
    BSR     SetTextColor        * Set the text color to operand color

    MOVE.B  D4,D1
    BTST.L  #5,D3               * If the i/r is 0:
    BEQ     .ImmediateCount     *   Immediate count
                                * Else:
                                *   Register count

.RegisterCount
    BSR     DisplayDataDirect   * Display data register source
    BRA     .RegisterShiftCont

.ImmediateCount
    BSR     DisplayImmediateByte    * Display immediate data source

.RegisterShiftCont
    BSR     DisplayComma        * Display ','

    MOVE.B  D5,D1
    BSR     DisplayDataDirect   * Display data register destination

    BRA     .Return

.MemoryShift
    MOVE.B  #1,D1               * Memory shifts are all word sized
    BSR     DisplayInstAndSize  * Display the instruction and the size modifier

    MOVE.W  D3,D1
    MOVE.B  #5,D2
    BSR     ExtractEA           * Extract the effective address

    MOVE.L  D0,D1
    MOVE.B  D6,D2
    MOVE.B  #%01111100,D3
    BSR     DisplayEA           * Display the effective address

    MOVE.B  D0,D1
    CLR.B   D2
    BSR     DisplayUnsupported  * Display the unsupported EA message if needed

.Return
    MOVEM.L (SP)+,.Registers    * Restore D0 to D6
    RTS


*------------------------------------------------------------------------------
* Constants
*------------------------------------------------------------------------------
ASd     DC.B    'AS',0,0
LSd     DC.B    'LS',0,0
ROd     DC.B    'RO',0,0








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
