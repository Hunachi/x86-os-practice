call_gate:
    ; X axis
    ; Y axis
    ; color
    ; word
    ; ( code segment )
    push    ebp
    mov     ebp, esp

    pusha
    push    ds
    push    es
    
    mov     ax, 0x0010
    mov     ds, ax
    mov     es, ax

    ; Display words
    mov     eax, dword [ebp + 12]   ; x
    mov     ebx, dword [ebp + 16]   ; y
    mov     ecx, dword [ebp + 20]   ; color
    mov     edx, dword [ebp + 24]   ; word
    cdecl   draw_str, eax, ebx, ecx, edx

    pop     es
    pop     ds
    popa

    mov     esp, ebp
    pop     ebp

    ; 自動復帰してくれないから引数の調節を行う（今回の場合だと、32bitの値が4つスタックに積まれているため）
    retf 4 * 4
