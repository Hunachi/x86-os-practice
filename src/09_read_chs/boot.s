; Reference: 作って理解するOS x86系コンピュータを動かす理論と実装 (https://gihyo.jp/book/2019/978-4-297-10847-2)
%include    "../include/macro.s"
%include    "../include/define.s"

    ORG     BOOT_LOAD           ; Instruct load address to assembler.
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

    mov     [BOOT + drive.no], dl

    cdecl   puts, .s0

    ; Read all rest sector
    mov     bx, BOOT_SECT - 1
    mov     cx, BOOT_LOAD + SECT_SIZE

    cdecl   read_chs, BOOT, bx, cx

    cmp     ax, bx
.10Q:
    jz      .10E
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
    istruc  drive
        at  drive.no,   dw 0 ; Drive number
        at  drive.cyln, dw 0 ; C: Cylinder
        at  drive.head, dw 0 ; H: Head
        at  drive.sect, dw 2 ; S: Sector
    iend

; Module
%include    "../modules/real/puts.s"
%include    "../modules/real/reboot.s"
%include    "../modules/real/read_chs.s"

    times    510-($-$$) db 0x00
    db      0x55, 0xAA

stage_2:
    cdecl   puts, .s0

    ; Finish program
    jmp     $

.s0     db "2ed stage...", 0x0A, 0x0D, 0

; Padding (This file size should be 8K.)
    times   BOOT_SIZE - ($ - $$)     db 0
    