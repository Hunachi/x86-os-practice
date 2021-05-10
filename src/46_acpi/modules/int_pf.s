int_pf:

    push    ebp
    mov     ebp, esp

    pusha
    push    ds
    push    es

    ; Setting for data segment
    mov		ax, 0x0010
	mov		ds, ax
	mov		es, ax

    ; Check address when exception occure
    mov     eax, cr2
    and     eax, ~0x0FFF 
    cmp     eax, 0x0010_7000    ; if page fault exception
    jne     .10F

    mov     [0x00106000 + 0x107 * 4], dword 0x00107007  ; Enable the page
    cdecl   memcpy, 0x0010_7000, DRAW_PARAM, rose_size  ; For task3

    jmp     .10E
.10F:

    add     esp, 4              ; pop es
    add     esp, 4              ; pop ds
    popa
    pop     ebp

    pushf
    push    cs
    push    int_stop

    mov     eax, .s0
    iret

.10E:

    pop     es
    pop     ds
    popa

    mov     esp, ebp
    pop     ebp

    add     esp, 4      ; Remove error code.
    iret

.s0     db " < PAGE FAULT > ", 0