%macro  cdecl 1-*.nolist

    %rep    %0 - 1
        push    %{-1:-1}
        %rotate -1
    %endrep
    %rotate -1

        call    %1
    
    %if 1 < %0
        add     sp, (__BITS__ >> 3) * (%0 - 1)
    %endif

%endmacro

%macro  set_vect 1-*.nolist
		push	eax
		push	edi

		mov		edi, VECT_BASE + (%1 * 8)		; vector address
		mov		eax, %2

		%if 3 == %0
			mov		[edi + 4], %3				; flag
		%endif

		mov		[edi + 0], ax					; exception address [15: 0]
		shr		eax, 16							; 
		mov		[edi + 6], ax					; exception address [31:16]

		pop		edi
		pop		eax
%endmacro

; port output
%macro  outp 2
        mov     al, %2
        out     %1, al
%endmacro

; Setting discriptor's base and limit
; set_desc(discriptor address, base address)
%macro  set_desc 2-* 
		push	eax
		push	edi

		mov		edi, %1							; discriptor address
		mov		eax, %2							; base address

	%if 3 == %0
		mov		[edi + 0], %3					; limit
	%endif

		mov		[edi + 2], ax					; base ([15: 0])
		shr		eax, 16							; 
		mov		[edi + 4], al					; base ([23:16])
		mov		[edi + 7], ah					; base ([31:24])

		pop		edi
		pop		eax
%endmacro

; Setting gate descriptor
; set_gate(descriptor address, offset)
%macro  set_gate 2-* 
		push	eax
		push	edi

		mov		edi, %1							; discriptor address
		mov		eax, %2							; offset 

		mov		[edi + 0], ax					; base（[15: 0]）
		shr		eax, 16							; 
		mov		[edi + 6], ax					; base（[31:16]）

		pop		edi
		pop		eax
%endmacro


; ~~ Structure ~~

; Drive parameter
struc drive
        .no         resw    1       ; Drive Number
        .cyln       resw    1       ; Cylinder
        .head       resw    1       ; HEAD
        .sect       resw    1       ; Sector
endstruc

; Ring buffer
%define		RING_ITEM_SIZE		(1 << 4)
%define		RING_INDEX_MASK		(RING_ITEM_SIZE - 1)

struc ring_buff
		.rp				resd	1				; RP: read point
		.wp				resd	1				; WP: write point
		.item			resb	RING_ITEM_SIZE	; buffer
endstruc

; rose curve parameter
struc rose
		.x0				resd	1				; 左上座標：X0
		.y0				resd	1				; 左上座標：Y0
		.x1				resd	1				; 右下座標：X1
		.y1				resd	1				; 右下座標：Y1

		.n				resd	1				; 変数：n
		.d				resd	1				; 変数：d

		.color_x		resd	1				; 描画色：X軸
		.color_y		resd	1				; 描画色：Y軸
		.color_z		resd	1				; 描画色：枠
		.color_s		resd	1				; 描画色：文字
		.color_f		resd	1				; 描画色：グラフ描画色
		.color_b		resd	1				; 描画色：グラフ消去色

		.title			resb	16				; タイトル
endstruc