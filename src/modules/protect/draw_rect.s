draw_rect:

    push    ebp
    mov     ebp, esp

    push    eax
    push    ebx
    push    ecx
    push    edx
    push    esi

    mov     eax, [ebp + 8]  ; x0
    mov     ebx, [ebp + 12] ; y0
    mov     ecx, [ebp + 16] ; x1
    mov     edx, [ebp + 20] ; y1
    mov     esi, [ebp + 24] ; color

    ; modify to x0 < x1 && y0 < y1
    cmp     eax, ecx
    jl      .10E
    xchg    eax, ecx
.10E:
    cmp     ebx, edx
    jl      .20E
    xchg    ebx, edx
.20E:

    ; Draw
    cdecl   draw_line, eax, ebx, ecx, ebx, esi  ; top
    cdecl   draw_line, eax, ebx, eax, edx, esi  ; left 

    dec     edx                                 ; dec bottom line
    cdecl   draw_line, eax, edx, ecx, edx, esi  ; bottom
    inc     edx

    dec     ecx
    cdecl   draw_line, ecx, ebx, ecx, edx, esi  ; right

    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp

    ret
