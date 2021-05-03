%include	"../include/define.s"
%include	"../include/macro.s"

    ORG     KERNEL_LOAD

[BITS 32]
kernel:

    ; Get Font Address
    mov     esi, BOOT_LOAD + SECT_SIZE
    movzx   eax, word[esi + 0]
    movzx   ebx, word[esi + 2]
    shl     eax, 4
    add     eax, ebx
    mov     [FONT_ADR], eax

    ; display word
    cdecl   draw_char, 0, 0, 0x010F, 'A'
    cdecl   draw_char, 1, 0, 0x010F, 'B'
    cdecl   draw_char, 2, 0, 0x010F, 'C'

    cdecl   draw_char, 0, 0, 0x0402, '0'
    cdecl   draw_char, 1, 0, 0x0212, '1'
    cdecl   draw_char, 2, 0, 0x0212, '_'

    jmp     $

ALIGN   4, db 0
FONT_ADR:   dd 0

; Module
%include    "../modules/protect/vga.s"
%include    "../modules/protect/draw_char.s"

; Padding
    times KERNEL_SIZE - ($ - $$) db 0x00
    