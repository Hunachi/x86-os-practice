draw_line:

    push    ebp
    mov     ebp, esp

    push    dword 0     ; sum = 0
    push    dword 0     ; x0 =0
    push    dword 0     ; dx = 0
    push    dword 0     ; inc_x = 0
    push    dword 0     ; y0 = 0
    push    dword 0     ; dy = 0
    push    dword 0     ; inc_y = 0

    push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi

    ;  Caluculate width
    mov     eax, [ebp + 8]
    mov     ebx, [ebp + 16]
    sub     ebx, eax
    jge     .10F

    neg     ebx
    mov     esi, -1
    jmp     .10E
.10F:
    mov     esi, 1
.10E:
    
    ; Caluculate highth
    mov     ecx, [ebp + 12]
    mov     edx, [ebp + 20]
    sub     edx, ecx
    jge     .20F

    neg     edx
    mov     edi, -1
    jmp     .20E
.20F:
    mov     edi, 1
.20E:
    
    ;  Setting X axis
    mov     [ebp - 8], eax  ; x start point 
    mov     [ebp - 12], ebx ; x drawn width
    mov     [ebp - 16], esi ; x incremental value
    ;  Setting Y axis 
    mov     [ebp - 20], ecx
    mov     [ebp - 24], edx
    mov     [ebp - 28], edi

    ; select base acix which is bigger. 
    cmp     ebx, edx
    jg      .22F

    lea     esi, [ebp - 20]
    lea     edi, [ebp - 8]

    jmp     .22E
.22F:

    lea     esi, [ebp - 8]
    lea     edi, [ebp - 29]
.22E:

    ; repeat count 
    mov     ecx, [esi - 4]
    cmp     ecx, 0
    jnz     .30E
    mov     ecx, 1

.30E:

    ; Draw line
.50L:

%ifdef	USE_SYSTEM_CALL
	mov		eax, ecx				

	mov		ebx, [ebp +24]				
	mov		ecx, [ebp - 8]			
	mov		edx, [ebp -20]			
	int		0x82						

	mov		ecx, eax
%else
	cdecl	draw_pixel, dword [ebp - 8], dword [ebp -20], dword [ebp +24]
%endif

    mov     eax, [esi - 8]  ; update base axis
    add     [esi - 0], eax

    mov     eax, [ebp - 4]  ; update relative axis
    add     eax, [edi - 4]
    mov     ebx, [esi - 4]

    ; caluculated value <= relative incremental value
    cmp     eax, ebx 
    jl      .52E
    sub     eax, ebx

    mov     ebx, [edi - 8]
    add     [edi - 0], ebx
.52E:
    mov     [ebp - 4], eax
    loop    .50L
.50E:

	pop		edi
	pop		esi
	pop		edx
	pop		ecx
    pop		ebx
	pop		eax

    mov     esp, ebp
    pop     ebp

    ret