memcpy:
    ; Construct stackframe
    push    bp
    mov     bp, sp
    
    ; Store registers
    push    cx
    push    si
    push    di
    
    ; Copy each byte.
    cld
    mov     di, [bp + 4]
    mov     si, [bp + 6]
    mov     cx, [bp + 8]

    rep     movsb ; while (*edi++ == *esi++)

    ; Restore registers
    pop     di
    pop     si
    pop     cx

    ; Clear stackframe
    mov     sp, bp
    pop     bp

    ret
