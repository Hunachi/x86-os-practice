memcpy:
    ; Construct stackframe.
    push    ebp
    mov     ebp, esp
    
    ; Save arguments to registers.
    push    ecx
    push    esi
    push    edi
    
    ; Copy each byte.
    cld
    mov     edi, [ebp + 8]
    mov     esi, [ebp + 12]
    mov     ecx, [ebp + 16]

    rep     movsb ; while (*edi++ == *esi++)

    ; Restore registers.
    pop     edi
    pop     esi
    pop     ecx

    ; Remove stackframe.
    mov     esp, ebp
    pop     ebp

    ret
