task_3:

    mov     ebp, esp

    push    dword 0 ; x0
    push    dword 0 ; y0
    push    dword 0 ; x
    push    dword 0 ; y
    push    dword 0 ; r

    ; directly set logic address
    mov     esi, 0x0010_7000

    ; Display title
    mov     eax, [esi + rose.x0]
    mov     ebx, [esi + rose.y0]

    shr     eax, 3
    shr     ebx, 4
    dec     ebx
    mov     ecx, [esi + rose.color_s]
    lea     edx, [esi + rose.title]

    cdecl	draw_str, eax, ebx, ecx, edx

    ; Center of X axis
    mov     eax, [esi + rose.x0]
    mov     ebx, [esi + rose.x1]
    sub     ebx, eax
    shr     ebx, 1                  ; ebx/2
    add     ebx, eax
    mov     [ebp - 4], ebx

    ; Center of Y asis
    mov     eax, [esi + rose.y0]
    mov     ebx, [esi + rose.y1]
    sub     ebx, eax
    shr     ebx, 1                  ; ebx/2
    add     ebx, eax
    mov     [ebp - 8], ebx

    ; Display X axis
    mov     eax, [esi + rose.x0]
    mov     ebx, [ebp - 8]
    mov     ecx, [esi + rose.x1]

    cdecl   draw_line, eax, ebx, ecx, ebx, dword [esi + rose.color_x]

    ; Display Y axis
    mov     eax, [esi + rose.y0]
    mov     ebx, [ebp - 4]
    mov     ecx, [esi + rose.y1]

    cdecl   draw_line, ebx, eax, ebx, ecx, dword [esi + rose.color_y]

    ; Display frame.
    mov     eax, [esi + rose.x0]
    mov     ebx, [esi + rose.y0]
    mov     ecx, [esi + rose.x1]
    mov     edx, [esi + rose.y1]

    cdecl   draw_rect, eax, ebx, ecx, edx, dword [esi + rose.color_z]

    ; make amplitude 95% of x axis
    mov     eax, [esi + rose.x1]
    sub     eax, [esi + rose.x0]
    shr     eax, 1
    mov     ebx, eax
    shr     ebx, 4
    sub     eax, ebx

    ; Initialize FPU
    cdecl   fpu_rose_init, eax, dword[esi + rose.n], dword[esi + rose.d]

    ; Main Loop
.10L:
    lea     ebx, [ebp - 12]
    lea     ecx, [ebp - 16]
    mov     eax, [ebp - 20]

    cdecl   fpu_rose_update, ebx, ecx, eax

    ; Update rad
    mov     edx, 0
    inc     eax
    mov     ebx, 360 * 100
    div     ebx
    mov     [ebp - 20], edx

    ; Display dot
    mov     ecx, [ebp - 12]
    mov     edx, [ebp - 16]
    add     ecx, [ebp - 4]
    add     edx, [ebp - 8]

    mov     ebx, [esi + rose.color_f]
    int     0x82

    ; Wait
    cdecl   wait_tick, 2

    ; Remove dot
    mov     ebx, [esi + rose.color_b]
    int     0x82

    jmp     .10L

ALIGN 4, db 0
DRAW_PARAM:
	istruc	rose
		at	rose.x0,		dd		 16			; 左上座標：X0
		at	rose.y0,		dd		 32			; 左上座標：Y0
		at	rose.x1,		dd		416			; 右下座標：X1
		at	rose.y1,		dd		432			; 右下座標：Y1

		at	rose.n,			dd		2			; 変数：n
		at	rose.d,			dd		1			; 変数：d

		at	rose.color_x,	dd		0x0007		; 描画色：X軸
		at	rose.color_y,	dd		0x0007		; 描画色：Y軸
		at	rose.color_z,	dd		0x000F		; 描画色：枠
		at	rose.color_s,	dd		0x030F		; 描画色：文字
		at	rose.color_f,	dd		0x000F		; 描画色：グラフ描画色
		at	rose.color_b,	dd		0x0003		; 描画色：グラフ消去色

		at	rose.title,		db		"Task-3", 0	; タイトル

	iend


; rose curve
;	x = A * sin(nθ) * cos(θ)
;	y = A * sin(nθ) * sin(θ)
fpu_rose_init:
; Args: A, n, d
    push    ebp
    mov     ebp, esp

    push    dword 180

    ; with FUP
; ---------+---------+---------|---------|---------|---------|
;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
; ---------+---------+---------|---------|---------|---------|
;     A    |   n/d   | d=pi/180|         |         |         |
; ---------+---------+---------|---------|---------|---------|
    fldpi
    fidiv   dword [ebp - 4]
    fild    dword [ebp + 12]
    fidiv   dword [ebp + 16]
    fild    dword [ebp + 8]

    mov     esp, ebp
    pop     ebp
    ret

fpu_rose_update:
    ; Args: lad, X coordinate pointer, Y coodinate pointer
    push    ebp
    mov     ebp, esp

    push    eax
    push    ebx

    mov     eax, [ebp + 8]
    mov     ebx, [ebp + 12]

; FPU
; ---------+---------+---------|---------|---------|---------|
;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
; ---------+---------+---------|---------|---------|---------|
;    x     |    y    |    θ    |    A    |   n/d   | d=pi/180|
; ---------+---------+---------|---------|---------|---------|

    fild    dword [ebp + 16]
    fmul    st0, st3 
    fld     st0    

    fsincos
    fxch    st2 
    fmul    st0, st4
    fsin
    fmul    st0, st3 

    ;---------------------------------------
	; x =  A * sin(kθ) * cos(θ);
	;---------------------------------------
    fxch    st2
    fmul    st0, st2
    fistp   dword[eax]
    
    ;---------------------------------------
	; y = -A * sin(kθ) * sin(θ);
	;---------------------------------------
    fmulp   st1, st0 
    fchs
    fistp   dword [ebx]

    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp
    ret
