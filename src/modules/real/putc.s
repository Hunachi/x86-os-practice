putc:
    push    bp
    mov     bp, sp

    push    ax
    push    bx

    mov     al, [bp + 4]    ; AL = output word
    mov     ah, 0x0E        ; teletype's single word output
    mov     bx, 0x0000      ; setting page number and word's color 0
    int     0x10            ; call video BIOS.

    pop     bx
    pop     ax

    mov     sp, bp
    pop     bp

    ret