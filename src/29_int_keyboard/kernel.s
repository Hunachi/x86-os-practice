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

    ; initializetion
    cdecl   init_int                ; Initialize interrupt vector
    cdecl   init_pic                ; Initialize interrupt controller

    set_vect    0x00, int_zero_dev  ; Apply division by zero's interrupt
    set_vect    0x21, int_keyboard  ; Apply KBC interrupt
    set_vect    0x28, int_rtc       ; Apply RTC interrupt

    ; Allow Device interrupt
    cdecl   rtc_int_en, 0x10

    ; Setting IMR(Interrupt mask register)
    outp    0x21, 0b1111_1001   ; Enable Interrupt: slave PIC/KBC 
    outp    0xA1, 0b1111_1110   ; Enable Interrupt: RTC

    ; Enable CPU Interrupt
    sti

    ; display fonts
    cdecl   draw_font, 63, 13
    ; display colorbar
    cdecl   draw_color_bar, 63, 4

    ; draw_str(.s0)
    cdecl   draw_str, 25, 14, 0x010F, .s0


.10L:
    ; draw time
	mov     eax, [RTC_TIME]                 ; Get time
	cdecl	draw_time, 72, 0, 0x0700, eax   ; display time

    ; get keycode from keyboard
    cdecl   ring_rd, _KEY_BUFF, .int_key
    cmp     eax, 0
    je      .10E
    ; Display keycode
    cdecl   draw_key, 2, 29, _KEY_BUFF
.10E:
    jmp     .10L

.s0:    db " Hello, HunachiOS!! ", 0

ALIGN   4,  db 0
.int_key:   dd 0

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
%include	"../modules/protect/interrupt.s"
%include    "../modules/protect/pic.s"
%include    "../modules/protect/int_rtc.s"
%include	"../modules/protect/int_keyboard.s"
%include	"../modules/protect/ring_buff.s"

; Padding
    times KERNEL_SIZE - ($ - $$) db 0x00
    