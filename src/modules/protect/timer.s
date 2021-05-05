; Setting Timer
int_en_timer0:
    
    push    eax

    ;	8254 Timer
	;	0x2e9c(11932)=10[ms] @ CLK=1,193,182[Hz]
    outp    0x43, 0b_00_11_010_0
    outp    0x40, 0x9C
    outp    0x40, 0x2E

    pop     eax
    ret
