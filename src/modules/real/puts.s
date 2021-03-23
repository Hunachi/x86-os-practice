puts:
    push    bp
    mov     bp, sp

    push    ax
    push    bx
    push    si

    mov     si, [bp + 4]    ; Address of string.

    ; Start program
    mov     ah, 0x0E        ; teletype's single word output
    mov     bx, 0x0000      ; setting page number and word's color 0
    cld                     ; DF = 0 ; Add Address.
.10L:
    lodsb                   ; al = *si++;

    cmp     al, 0
    je      .10E

    int     0x10            ; call video BIOS.
    jmp     .10L

.10E:
    pop     si
    pop     bx
    pop     ax

    mov     sp, bp
    pop     bp

    ret