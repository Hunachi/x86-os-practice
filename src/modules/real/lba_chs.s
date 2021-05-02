lba_chs:

    push    bp
    mov     bp, sp

    push    si
    push    di
    push    bx
    push    ax
    push    dx

    mov     si, [bp + 4]
    mov     di, [bp + 6]

    mov     al, [si + drive.head]
    mul     byte [si + drive.sect] ; ax = max head coun * max sector count
    mov     bx, ax

    mov     dx, 0
    mov     ax, [bp + 8]
    div     bx

    mov     [di + drive.cyln], ax

    mov     ax, dx
    div     byte [si + drive.sect]

    movzx   dx, ah
    inc     dx

    mov     ah, 0x00

    mov     [di + drive.head], ax
    mov     [di + drive.sect], dx

    pop     dx
    pop     ax
    pop     bx
    pop     di
    pop     si 

    mov     sp, bp
    pop     bp
    ret
