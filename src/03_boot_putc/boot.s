; Reference: 作って理解するOS x86系コンピュータを動かす理論と実装 (https://gihyo.jp/book/2019/978-4-297-10847-2)

    BOOT_LOAD equ 0x7C00 ; Address of boot program

    ORG BOOT_LOAD        ; Instract load address to assembler.

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

    mov     al, 'A'     ; AL = output word
    mov     ah, 0x0E    ; teletype's single word output
    mov     bx, 0x0000  ; setting page number and word's color 0
    int     0x10        ; call video BIOS.

    jmp     $

ALIGN 2, db 0
BOOT:
.DRIVE:     dw 0

    times    510-($-$$) db 0x00
    db      0x55, 0xAA
