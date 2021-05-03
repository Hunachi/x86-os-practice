draw_char:
    
    push    ebp
    mov     ebp, esp

    push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi

    ; Setting copy src font address
    movzx   esi, byte[ebp + 20]
    shl     esi, 4
    add     esi, [FONT_ADR]

    ; Get copy dist address
    ; Adr = 0xA000 + (640 / 8 * 16) * y + x
    mov     edi, [ebp + 12]                 ; Y
    shl     edi, 8
    lea     edi, [edi * 4 + edi + 0xA0000]
    add     edi, [ebp + 8]                  ; X

    ; Display 1 word font
    movzx   ebx, word[ebp + 16]     ; color

    cdecl   vga_set_read_plane, 0x03
    cdecl   vga_set_write_plane, 0x08
    cdecl   vram_font_copy, esi, edi, 0x08, ebx

    cdecl   vga_set_read_plane, 0x02    ; Red
    cdecl   vga_set_write_plane, 0x04   ; Red
    cdecl   vram_font_copy, esi, edi, 0x04, ebx
    
    cdecl   vga_set_read_plane, 0x01    ; Green
    cdecl   vga_set_write_plane, 0x02   ; Green
    cdecl   vram_font_copy, esi, edi, 0x02, ebx

    cdecl   vga_set_read_plane, 0x00    ; Blue
    cdecl   vga_set_write_plane, 0x01   ; Blue
    cdecl   vram_font_copy, esi, edi, 0x01, ebx

    pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

    mov     esp, ebp
    pop     ebp

    ret
    