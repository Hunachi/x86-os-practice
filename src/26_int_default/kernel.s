%include	"../include/define.s"
%include	"../include/macro.s"

    ORG     KERNEL_LOAD

[BITS 32]
kernel:

    ; Get Font Address
    mov     esi, BOOT_LOAD + SECT_SIZE
    movzx   eax, word[esi + 0]
    movzx   ebx, word[esi + 2]
    shl     eax, 4
    add     eax, ebx
    mov     [FONT_ADR], eax

    ; display fonts
    cdecl   draw_font, 63, 13
    ; display colorbar
    cdecl   draw_color_bar, 63, 4

    ; draw_str(.s0)
    cdecl   draw_str, 25, 14, 0x010F, .s0

        ; draw line
	cdecl	draw_line, 100, 100,   0,   0, 0x0F
	cdecl	draw_line, 100, 100, 200,   0, 0x0F
	cdecl	draw_line, 100, 100, 200, 200, 0x0F
	cdecl	draw_line, 100, 100,   0, 200, 0x0F

	cdecl	draw_line, 100, 100,  50,   0, 0x02
	cdecl	draw_line, 100, 100, 150,   0, 0x03
	cdecl	draw_line, 100, 100, 150, 200, 0x04
	cdecl	draw_line, 100, 100,  50, 200, 0x05

	cdecl	draw_line, 100, 100,   0,  50, 0x02
	cdecl	draw_line, 100, 100, 200,  50, 0x03
	cdecl	draw_line, 100, 100, 200, 150, 0x04
    cdecl	draw_line, 100, 100,   0, 150, 0x05

	cdecl	draw_line, 100, 100, 100,   0, 0x0F
	cdecl	draw_line, 100, 100, 200, 100, 0x0F
	cdecl	draw_line, 100, 100, 100, 200, 0x0F
	cdecl	draw_line, 100, 100,   0, 100, 0x0F

    ; draw rect
    cdecl	draw_rect, 100, 100, 200, 200, 0x03
	cdecl	draw_rect, 400, 250, 200, 150, 0x05
	cdecl	draw_rect, 350, 400, 300, 100, 0x06

    push    0x11223344
    pushf
    call    0x0008:int_default

    ; draw time
.10L:											; do
												; {
	cdecl	rtc_get_time, RTC_TIME			;   EAX = get_time(&RTC_TIME);
	cdecl	draw_time, 72, 0, 0x0700,		\
						dword [RTC_TIME]
	jmp		.10L


    jmp     $

.s0:    db " Hello, HunachiOS!! ", 0

ALIGN   4,  db 0
FONT_ADR:   dd 0
RTC_TIME:	dd 0

; Module
%include    "../modules/protect/vga.s"
%include    "../modules/protect/draw_char.s"
%include    "../modules/protect/draw_font.s"
%include    "../modules/protect/draw_str.s"
%include    "../modules/protect/draw_color_bar.s"
%include    "../modules/protect/draw_pixel.s"
%include    "../modules/protect/draw_line.s"
%include    "../modules/protect/draw_rect.s"
%include	"../modules/protect/rtc.s"
%include	"../modules/protect/itoa.s"
%include	"../modules/protect/draw_time.s"
%include	"modules/interrupt.s"

; Padding
    times KERNEL_SIZE - ($ - $$) db 0x00
    