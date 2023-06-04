*------------------------------------------------------------------------------
* Title      : 
* Written by : Dillon Evans
* Date       : 
* Description: 
*------------------------------------------------------------------------------
    ORG     $6000

    ADD.B   D0,D1
    ADD.W   D2,D3
    ADD.L   D4,D5
    ADD.W   A0,D7
    ADD.B   (A0),D7
    ADD.L   (A0)+,D7
    ADD.B   -(A0),D7
    ADD.L   $1234,D7
    ADD.W   $A000,D7
    ADD.W   D7,(A0)
    ADD.L   D7,(A0)+
    ADD.B   D7,-(A0)
    ADD.L   D7,$1234
    ADD.W   D7,$A000







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
