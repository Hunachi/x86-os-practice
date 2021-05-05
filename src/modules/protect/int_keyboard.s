; Interrupt for KBC
int_keyboard:
    pusha
    push    ds
    push    es

    mov     ax, 0x0010
    mov     ds, ax
    mov     es, ax

    ; Read KBC buffer
    in      al, 0x60

    ; Save keycode
    cdecl   ring_wr, _KEY_BUFF, eax     ; call ring_wr(buff, data address)

    ; Send interrupt finish command
    outp    0x20, 0x20

    pop     es
    pop     ds
    popa 

    iret

ALIGN 4, db 0
_KEY_BUFF: times ring_buff_size db 0

