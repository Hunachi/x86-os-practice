; DNA ( Device Not Available ) interrupt
int_nm:
    pusha
    push    ds
    push    es

    mov     ax, DS_KERNEL
    mov     ds, ax
    mov     es, ax

    ; Clear TS ( task switch ) flag.
    clts

    mov     edi, [.last_tss]
    str     esi                 ; current task
    and     esi, ~0x0007        ; Mask provolege level bit

    ; Check FPU first use.
    cmp     edi, 0
    je      .10F

    cmp     esi, edi
    je      .12E

    ; Save previous FPU context
    mov     ebx, edi
    call    get_tss_base
    call    save_fpu_context

    ; Recover curret FPU context
    mov     ebx, esi
    call    get_tss_base
    call    load_fpu_context
    
    sti
.12E:
    jmp     .10E
.10F:
    
    cli

    ; Recover current FPU context
    mov     ebx, esi
    call    get_tss_base
    call    load_fpu_context

    sti
.10E:
    mov		[.last_tss], esi

    pop     es
    pop     ds
    popa

    iret

ALIGN   4, db   0
.last_tss:  dd  0

get_tss_base:
    ; ebx:TSS selector
    mov     eax, [GDT + ebx + 2]
    shl     eax, 8
    mov     al,  [GDT + ebx + 7]
    ror     eax, 8
    ; eax:TSS descriptor's base address
    ret

save_fpu_context:
    ; eax:TSS descriptor's base address
    fnsave  [eax + 104]                 ; Save FPU context
    mov     [eax + 104 + 108], dword 1  ; saved = 1

    ret

load_fpu_context:
    ; eax:TSS head address
    cmp     [eax + 104 + 108], dword 0
    jne     .10F
    fninit                              ; Clear FPU
    jmp     .10E
.10F:
    frstor  [eax + 104]
.10E:
    ret
