vga_set_read_plane:

    push    ebp
    mov     ebp, esp

    push    edx
    push    eax

    ; Select read plane
    mov     ah, [ebp + 8]   ; plane
    and     ah, 0x03        ; remove needless bit 
    mov     al, 0x04        ; read map selection register
    mov     dx, 0x03CE      ; Graphic control port
    out     dx, ax

    pop     edx
    pop     eax

    mov     esp, ebp
    pop     ebp

    ret

vga_set_write_plane:

    push    ebp
    mov     ebp, esp

    push    edx
    push    eax

    ; Select write plane
    mov     ah, [ebp + 8]
    and     ah, 0x0F
    mov     al, 0x02
    mov     dx, 0x03C4
    out     dx, ax

    pop     eax
    pop     edx

    mov     esp, ebp
    pop     ebp

    ret

vram_font_copy:

    push    ebp
    mov     ebp, esp

    push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi

    mov     esi, [ebp + 8]      ; Font Address
    mov     edi, [ebp + 12]     ; VRAM Address
    movzx   eax, byte[ebp + 16] ; plane
    movzx   ebx, word[ebp + 20] ; color

    ; background color & plane
    test    bh, al
    setz    dh
    dec     dh 

    ; front colr & plane
    test    bl, al
    setz    dl
    dec     dl

    ; Copy 16 dit font
    cld 

    mov     ecx, 16
.10L:
    ; Create font mask
    lodsb
    mov     ah, al
    not     ah

    ; Front color
    and     al, dl

    ; background color 
    test    ebx, 0x0010
    jz      .11F
    and     ah, [edi]   ; Transparent mode
    jmp     .11E
.11F:
    and     ah, dh      ; Not transparent mode
.11E:

    ; Marge front color and background color
    or      al, ah

    ; output new value
    mov     [edi], al

    add     edi, 80
    loop    .10L
.10E:

    pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

    mov     esp, ebp
    pop     ebp

    ret
