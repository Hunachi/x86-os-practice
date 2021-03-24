; Reference: 作って理解するOS x86系コンピュータを動かす理論と実装 (https://gihyo.jp/book/2019/978-4-297-10847-2)

    BOOT_LOAD   equ     0x7C00 ; Address of boot program

    ORG     BOOT_LOAD          ; Instract load address to assembler.

%include    "../include/macro.s"
; *****************
;    Entory Point 
; *****************
entry:
    jmp     ipl
    times    90-($-$$) db 0x90 ; BPB(BOPS Parameter Block)

ipl:
    cli     ; Disabling Inerrupt

    mov     ax, 0x0000
    mov     ds, ax
    mov     es, ax
    mov     ss, ax
    mov     sp, BOOT_LOAD

    sti

    mov     [BOOT.DRIVE], dl

    ; Print string
    cdecl   puts, .s0

    cdecl   reboot

    jmp     $

.s0     db  "Booting HunachiOS....", 0x0A, 0x0D, 0

ALIGN 2, db 0
BOOT:
.DRIVE:     dw 0

; Module
%include    "../modules/real/puts.s"
%include    "../modules/real/itoa.s"
%include    "../modules/real/reboot.s"

    times    510-($-$$) db 0x00
    db      0x55, 0xAA