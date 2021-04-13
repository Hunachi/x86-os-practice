read_chs:
    ; +8 copy dist | +6 sector size | +4 parameter buffer
    push    bp
    mov     bp, sp 
    push    3           ; retry = 3 ; Retry Number
    push    0           ; sect = 0 ; Reading Sector Number

    push    bx          
    push    cx          
    push    dx          
    push    es
    push    si

    ; start program
    mov     si, [bp + 4]    ; SI = SRC buffer

    ; Setting Cylinder
    mov     ch, [si + drive.cyln + 0]
    mov     cl, [si + drive.cyln + 1]
    shl     cl, 6
    or      cl, [si + drive.sect]

    ; Read Sector
    mov     dh, [si + drive.head]   ; dh = head number
    mov     dl, [si + 0]            ; dl = Drive number
    mov     ax, 0x0000              
    mov     es, ax                  ; es = segment
    mov     bx, [bp + 8]            ; bx = copy dst
.10L:
    mov     ah, 0x02
    mov     al, [bp + 6]

    int     0x13                    ; cf = BIOS(0x13, 0x02)
    jnc     .11E

    mov     al, 0
    jmp     .10E
.11E:
    cmp     al, 0
    jne     .10E

    mov     ax, 0
    dec     word [bp - 2]
    jnz     .10L
.10E:
    mov     ah, 0

    pop     si
    pop     es
    pop     dx
    pop     cx
    pop     bx

    mov     sp, bp
    pop     bp

    ret
    



