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

    cdecl   puts, .s0

    ; Read next 512 byte
    mov     ah, 0x02        ; AH = 読み込み命令
    mov     al, 1           ; AL = 読み込みセクタ数
    mov     cx, 0x0002      ; CX = シリンダ/セクタ
    mov     dh, 0x00
    mov     dl, [BOOT.DRIVE]
    mov     bx, 0x7C00 + 512
    int     0x13
.10Q:
    jnc     .10E
.10T:
    cdecl   puts, .e0
    call    reboot
.10E:

    ; Jamp nest stage
    jmp     stage_2

.s0     db  "Booting HunachiOS....", 0x0A, 0x0D, 0
.e0     db  "Error:sector read", 0

ALIGN 2, db 0
BOOT:
.DRIVE:     dw 0

; Module
%include    "../modules/real/puts.s"
%include    "../modules/real/itoa.s"
%include    "../modules/real/reboot.s"

    times    510-($-$$) db 0x00
    db      0x55, 0xAA

stage_2:
    cdecl   puts, .s0

    ; Finish program
    jmp     $

.s0     db "2ed stage...", 0x0A, 0x0D, 0

; Padding (This file size should be 8K.)
    times (1024 * 8) - ($ - $$)     db 0
    