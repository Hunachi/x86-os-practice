; Search on 4byte namespace like ACPI table.
acpi_find:
    ; Args:address, size, word

    push    ebp
    mov     ebp, esp

    push    ebx
    push    ecx
    push    edi

    mov     edi, [ebp + 8]
    mov     ecx, [ebp + 12]
    mov     eax, [ebp + 16]

    ; Search name
    cld
.10L:
    repne   scasb

    cmp     ecx, 0
    jnz     .11E
    mov     eax, 0
    jmp     .10E
.11E:
    cmp     eax, [es:edi - 1] ; Same 4word
    jne     .10L

    dec     edi
    mov     eax, edi
.10E:
    pop     edi
    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp

    ret