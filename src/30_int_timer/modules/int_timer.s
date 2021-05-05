; Timer interrupt
int_timer:

    pushad
    push    ds
    push    es

    mov     ax, 0x0010
    mov     ds, ax
    mov     es, ax

    ; TICK
    inc     dword [TIME_COUNT]

    ; Clear interrupt flag (EOI)
    outp    0x20, 0x20      ; Master PCI

    pop     es
    pop     ds
    popad

    iret

ALIGN   4, db 0
TIME_COUNT:     dq  0
