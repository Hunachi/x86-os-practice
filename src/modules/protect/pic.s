; PIC: Programmable Interrupt Comtroller
; all unable IC
init_pic:
    push    eax

    ; Master PIC
	outp	0x20, 0x11						; MASTER.ICW1 = 0x11;
	outp	0x21, 0x20						; MASTER.ICW2 = 0x20;
	outp	0x21, 0x04						; MASTER.ICW3 = 0x04;
	outp	0x21, 0x01						; MASTER.ICW4 = 0x01;
	outp	0x21, 0xFF						; Mask

    ; Slave PIC
	outp	0xA0, 0x11						; SLAVE.ICW1  = 0x11;
	outp	0xA1, 0x28						; SLAVE.ICW2  = 0x28;
	outp	0xA1, 0x02						; SLAVE.ICW3  = 0x02;
	outp	0xA1, 0x01						; SLAVE.ICW4  = 0x01;
	outp	0xA1, 0xFF						; Mask

    pop     eax

    ret
