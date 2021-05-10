%define     USE_SYSTEM_CALL
%define     USE_TEST_AND_SET

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

	; Setting TSS Descriptor
	set_desc	GDT.tss_0, TSS_0
	set_desc	GDT.tss_1, TSS_1
    set_desc	GDT.tss_2, TSS_2
    set_desc	GDT.tss_3, TSS_3
    set_desc	GDT.tss_4, TSS_4
    set_desc	GDT.tss_5, TSS_5
    set_desc	GDT.tss_6, TSS_6

    ; Setting call gate
    set_gate    GDT.call_gate, call_gate

	; Setting LDT
	set_desc	GDT.ldt, LDT, word LDT_LIMIT

	; Load GDT
	lgdt	[GDTR]

	; Setting stack
	mov 	esp, SP_TASK_0

	; Intialize task register
	mov 	ax, SS_TASK_0
	ltr 	ax

    ; Initializetion
    cdecl   init_int                ; Initialize interrupt vector
    cdecl   init_pic                ; Initialize interrupt controller
    cdecl   init_page               ; Initialize page table

    set_vect    0x00, int_zero_dev  ; Apply division by zero's interrupt
    set_vect    0x07, int_nm        ; Apply DNA interrupt
    set_vect    0x0E, int_pf        ; Apply PageFault interrupt
    set_vect    0x20, int_timer     ; Apply Timer interrupt
    set_vect    0x21, int_keyboard  ; Apply KBC interrupt
    set_vect    0x28, int_rtc       ; Apply RTC interrupt
    set_vect    0x81, trap_gate1, word 0xEF00   ; Apply trapgate:Display 1 word
    set_vect    0x82, trap_gate2, word 0xEF00   ; Apply trapgate:Display a dot

    ; Allow Device interrupt
    cdecl   rtc_int_en, 0x10
	cdecl	int_en_timer0

    ; Setting IMR(Interrupt mask register)
    outp    0x21, 0b1111_1000   ; Enable Interrupt: slave PIC/KBC/Timer
    outp    0xA1, 0b1111_1110   ; Enable Interrupt: RTC

    ; Enable paging
    mov     eax, CR3_BASE
    mov     cr3, eax
    mov     eax, cr0
    or      eax, (1 << 31)      ; CR0's PE bit = 1
    mov     cr0, eax
    jmp     $ + 2               ; Flush()

    ; Enable CPU Interrupt
    sti

    ; Display fonts
    cdecl   draw_font, 63, 13
    ; Display colorbar
    cdecl   draw_color_bar, 63, 4

    ; Draw_str(.s0)
    cdecl   draw_str, 25, 14, 0x010F, .s0

.10L:
    jmp     SS_TASK_1:0

    ; Display rotation bar
    cdecl   draw_rotation_bar

    ; Get keycode from keyboard
    cdecl   ring_rd, _KEY_BUFF, .int_key
    cmp     eax, 0
    je      .10E
    ; Display keycode
    cdecl   draw_key, 2, 29, _KEY_BUFF

    ; When push [1] key
    mov     al, [.int_key]
    cmp     al, 0x02
    jne     .12E

    ; Read a file
    call    [BOOT_LOAD + BOOT_SIZE - 16]

    ; Display file's contents
    mov     esi, 0x7800         ; 0x7800にエラ〜メッセージが入ってなさそう😭
    mov     [esi + 32], byte 0
    cdecl   draw_str, 0, 0, 0x010F, esi
.12E:
    ; Set Shutdown
    mov     al, [.int_key]
    cdecl   ctrl_alt_return, eax
    cmp     eax, 0
    je      .14E

    mov     eax, 0
    bts     [.once], eax
    jc      .14E
    cdecl   power_off
.14E:
.10E:
    jmp     .10L

.s0:    db " Hello, HunachiOS!! ", 0

ALIGN   4,  db 0
.int_key:   dd 0
.once:      dd 0

ALIGN   4,  db 0
FONT_ADR:   dd 0
RTC_TIME:	dd 0

; Task
%include	"descriptor.s"
%include	"modules/int_timer.s"
%include	"modules/paging.s"
%include	"modules/int_pf.s"
%include	"tasks/task_1.s"
%include	"tasks/task_2.s"
%include	"tasks/task_3.s"

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
%include	"../modules/protect/memcpy.s"
%include	"../modules/protect/draw_time.s"
%include	"../modules/protect/interrupt.s"
%include    "../modules/protect/pic.s"
%include    "../modules/protect/int_rtc.s"
%include	"../modules/protect/int_keyboard.s"
%include	"../modules/protect/ring_buff.s"
%include	"../modules/protect/timer.s"
%include	"../modules/protect/draw_rotation_bar.s"
%include	"../modules/protect/call_gate.s"
%include	"../modules/protect/trap_gate.s"
%include	"../modules/protect/test_and_set.s"
%include	"../modules/protect/int_nm.s"
%include	"../modules/protect/wait_tick.s"
%include	"../modules/protect/ctrl_alt_return.s"
%include	"../modules/protect/acpi_find.s"
%include	"../modules/protect/acpi_package_value.s"
%include	"../modules/protect/find_rsdt_entry.s"
%include	"../modules/protect/power_off.s"

; Padding
    times KERNEL_SIZE - ($ - $$) db 0x00

%include	"fat.s"