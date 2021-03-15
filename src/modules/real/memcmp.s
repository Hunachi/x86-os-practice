memcpy:
    ;  Construct stackframe
    push    bp
    mov     bp, sp
    
    ; Store register
    push    bx
    push    cx
    push    dx
    push    si
    push    di

    ; Get arguments
    cld
    mov     si, [bp + 4]
    mov     di, [bp + 6]
    mov     cx, [bp + 8]

    ; Compare each byte
    repe    cmpsb
    jnz     .10F
    mov     ax, 0
    jmp     .10E
.10F:
    mov     ax, -1
.10E:
    ; Restore registers
    pop     di
    pop     si
    pop     dx
    pop     cx
    pop     bx

    ; Clear stackframe
    mov     sp, bp
    pop     bp

    ret 
