get_font_adr:
    push    bp
    mov     bp, sp 

    push    ax
    push    bx          
    push    si
    push    es
    push    bp 

    ; start program
    mov     si, [bp + 4]    ; si = FONTアドレスの保存先

    mov     ax, 0x1113      ; Get font address
    mov     bh, 0x06        ; 8x16 font (vga/mcga)
    int     10h             ; ES:BP=FONT ADDRESS

    mov     [si + 0], es
    mov     [si + 2], bp
    
    pop     bp
    pop     es
    pop     si
    pop     bx
    pop     ax

    mov     sp, bp
    pop     bp

    ret
    



