; Read ring buffer
ring_rd:
    ; buff
    ; data

    push    ebp
    mov     ebp, esp

    push	ebx
	push	esi
	push	edi

    mov     esi, [ebp + 8]      ; ring buffer
    mov     edi, [ebp + 12]     ; data address

    ; check read position
    mov     eax, 0
    mov     ebx, [esi + ring_buff.rp]   ; reading position
    cmp     ebx, [esi + ring_buff.wp]   ; cmp with writing position
    je      .10E

    mov     al, [esi + ring_buff.item + ebx]    ; Save keycode

    mov     [edi], al                   ; Save data
    
    inc     ebx                         
    and     ebx, RING_INDEX_MASK
    mov     [esi, ring_buff.rp], ebx

    mov     eax, 1
.10E:

    pop     edi
    pop     ecx
    pop     ebx

    mov     esp, ebp
    pop     ebp

    ret

; Write ring buffer
ring_wr:
    ; buff 
    ; data
    push    ebp
    mov     ebp, esp

    push    ebx
    push    ecx
    push    esi

    mov     esi, [ebp + 8]              ; ring buffer

    mov     eax, 0
    mov     ebx, [esi + ring_buff.wp]   ; writing position 
    mov     ecx, ebx
    inc     ecx
    and     ecx, RING_INDEX_MASK

    cmp     ecx, [esi + ring_buff.rp]
    je      .10E

    mov     al, [ebp + 12]

    mov     [esi + ring_buff.item + ebx], al ; Save keycode
    mov     [esi + ring_buff.wp], ecx       ; Save writing position
    mov     eax, 1                      ; Success

.10E:

    pop     esi
    pop     ecx
    pop     ebx

    mov     esp, ebp
    pop     ebp

    ret

; Draw keyboard history 
draw_key:
    ; column
    ; row
    ; ring buffer

    push    ebp
    mov     ebp, esp

    pusha

    mov     edx, [ebp + 8]
    mov     edi, [ebp + 12]
    mov     esi, [ebp + 16]

    ; Get ring buffer infomation
    mov     ebx, [esi + ring_buff.rp]
    lea     esi, [esi + ring_buff.item]
    mov     ecx, RING_ITEM_SIZE

.10L:
    
    dec     ebx                     ; reading position
    and     ebx, RING_INDEX_MASK
    mov     al, [esi + ebx]

    cdecl   itoa, eax, .tmp, 2, 16, 0b0100  ; Convert keycode to word
    cdecl   draw_str, edx, edi, 0x02, .tmp  ; Display converted word

    add     edx, 3                  ; Refresh display position

    loop    .10L
.10E:

    popa

    mov     esp, ebp
    pop     ebp
    
    ret

.tmp    db "-- ", 0

