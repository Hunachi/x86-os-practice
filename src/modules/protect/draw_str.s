draw_str:

    push    ebp
    mov     ebp, esp

    push	eax
	push	ebx
	push	ecx	
    push	edx
	push	esi

    mov     ecx, [ebp + 8]      ; colmun
    mov     edx, [ebp + 12]     ; row
    movzx   ebx, word[ebp + 16] ; color
    mov     esi, [ebp + 20]     ; words address

    cld 
.10L:
    lodsb
    cmp     al, 0
    je      .10E

%ifdef  USE_SYSTEM_CALL
    int     0x81
%else
    ; display single word
    cdecl   draw_char, ecx, edx, ebx, eax
%endif
    
    inc     ecx
    cmp     ecx, 80     ; >= 80
    jl      .12E
    mov     ecx, 0
    inc     edx
    cmp     edx, 30     ; >= 30
    jl      .12E
    mov     edx, 0
.12E:
    jmp     .10L
.10E:

    pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

    mov     esp, ebp
    pop     ebp

    ret