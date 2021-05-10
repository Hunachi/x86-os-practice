; Create a page table
page_set_4m:

    push    ebp
    mov     ebp, esp

    pusha

    ; Create page directory (P=0)
    mov     edi, [ebp + 8]      ; Head of page directory
    mov     eax, 0x00000000     ; P=0
    mov     ecx, 1024
    rep stosd                   ; while(ecx--) *dst++ = attribute

    ; Setting the head entry
    mov     eax, edi
    and     eax, ~0x0000_0FFF   ; Physical address
    or      eax, 7
    mov     [edi - (1024 * 4)], eax

    ; Setting the page table
    mov     eax, 0x0000007
    mov     ecx, 1024

.10L:
    stosd
    add     eax, 0x00001000
    loop    .10L

    popa

    mov     esp, ebp
    pop     ebp

    ret


init_page:
    
    pusha

    cdecl   page_set_4m, CR3_BASE
    mov     [0x00106000 + 0x107 * 4], dword 0 ; Make 0x0010_7000 page absence 

    popa
    
    ret



