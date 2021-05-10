; Reference: 作って理解するOS x86系コンピュータを動かす理論と実装 (https://gihyo.jp/book/2019/978-4-297-10847-2)
%include    "../include/macro.s"
%include    "../include/define.s"

    ORG     BOOT_LOAD           ; Instruct load address to assembler.
; *****************
;    Entory Point 
; *****************
entry:
	; BPB(BIOS Parameter Block)
	jmp		ipl								; 0x00( 3) ブートコードへのジャンプ命令
	times	3 - ($ - $$) db 0x90			; 
	db		'OEM-NAME'						; 0x03( 8) OEM名
												; -------- --------------------------------
	dw		512								; 0x0B( 2) セクタのバイト数
	db		1								; 0x0D( 1) クラスタのセクタ数
	dw		32								; 0x0E( 2) 予約セクタ数
	db		2								; 0x10( 1) FAT数
	dw		512								; 0x11( 2) ルートエントリ数
	dw		0xFFF0							; 0x13( 2) 総セクタ数16
	db		0xF8							; 0x15( 1) メディアタイプ
	dw		256								; 0x16( 2) FATのセクタ数
	dw		0x10							; 0x18( 2) トラックのセクタ数
	dw		2								; 0x1A( 2) ヘッド数
	dd		0								; 0x1C( 4) 隠されたセクタ数
												; -------- --------------------------------
	dd		0								; 0x20( 4) 総セクタ数32
	db		0x80							; 0x24( 1) ドライブ番号
	db		0								; 0x25( 1) （予約）
	db		0x29							; 0x26( 1) ブートフラグ
	dd		0xbeef							; 0x27( 4) シリアルナンバー
	db		'BOOTABLE   '					; 0x2B(11) ボリュームラベル
	db		'FAT16   '	


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

; Information which got in real mode.
FONT:
    .seg:   dw 0
    .off:   dw 0
ACPI_DATA:
    .adr:   dd 0
    .len:   dd 0

; Module (allocate after head 512 byte)
%include    "../modules/real/itoa.s"
%include    "../modules/real/get_drive_param.s"
%include    "../modules/real/get_font_adr.s"
%include    "../modules/real/get_mem_info.s"
%include	"../modules/real/kbc.s"
%include	"../modules/real/lba_chs.s"
%include	"../modules/real/read_lba.s"

stage_2:
    cdecl   puts, .s0

    ; Get drive information
    cdecl   get_drive_param, BOOT
    cmp     ax, 0
.10Q:
    jne     .10E
.10T:
    cdecl   puts, .e1
    call    reboot
.10E:
    ; Display drive information
    mov     ax, [BOOT + drive.no]
    cdecl   itoa, ax, .p1, 2, 16, 0b0100
    mov     ax, [BOOT + drive.cyln]
    cdecl   itoa, ax, .p2, 4, 16, 0b0100
    mov     ax, [BOOT + drive.head]
    cdecl   itoa, ax, .p3, 2, 16, 0b0100
    mov     ax, [BOOT + drive.sect]
    cdecl   itoa, ax, .p4, 2, 16, 0b0100
    cdecl   puts, .s1

    ; Step next stage.
    jmp     stage_3

.s0     db "2ed stage...", 0x0A, 0x0D, 0

.s1     db " Drive:0x"
.p1     db "    , C:0x"
.p2     db "        , H:0x"
.p3     db "    , S:0x"
.p4     db "    ", 0x0A, 0x0D, 0

.e1     db "Can't gett drive parameter.", 0  

stage_3:
    cdecl puts, .s0

    ; Protect mode uses inner BIOS's font
    cdecl   get_font_adr, FONT

    ; Display Font Address
    cdecl   itoa, word [FONT.seg], .p1, 4, 16, 0b0100
    cdecl   itoa, word [FONT.off], .p2, 4, 16, 0b0100
    cdecl   puts, .s1

    ; Get and Display memory information
    cdecl   get_mem_info

    mov     eax, [ACPI_DATA.adr]
    cmp     eax, 0
    je      .10E

    cdecl   itoa, ax, .p4, 4, 16, 0b0100
    shr     eax, 16
    cdecl   itoa, ax, .p3, 4, 16, 0b0100

    cdecl   puts, .s2
.10E:

    ; Finish program
    jmp     stage_4

.s0     db "3rd stage..", 0x0A, 0x0D, 0
.s1     db " Font Address="
.p1     db "ZZZZ:"
.p2     db "ZZZZ:", 0x0A, 0x0D, 0
        db 0x0A, 0x0D, 0 

.s2:	db	" ACPI data="
.p3:	db	"ZZZZ"
.p4:	db	"ZZZZ", 0x0A, 0x0D, 0

stage_4:
    cdecl   puts, .s0
    ; Control KBC
    cli     ; prohibit interrupt
    cdecl   KBC_Cmd_Write, 0xAD   ; invalidate keyboard

    cdecl   KBC_Cmd_Write, 0xD0   ; Read Output port
    cdecl   KBC_Data_Read, .key     ; Output port data

    mov     bl, [.key]
    or      bl, 0x02

    cdecl   KBC_Cmd_Write, 0xD1
    cdecl   KBC_Data_Write, bx

    ; Activate Keyboard
    cdecl   KBC_Cmd_Write, 0xAE
    sti     ; permit interrupt

    cdecl   puts, .s1

    ; keyboard led test
    cdecl   puts, .s2

    mov     bx, 0
.10L:
    mov     ah, 0x00
    int     0x16

    cmp     al, '1'
    jb      .10E

    cmp     al, '3'
    ja      .10E

    mov     cl, al
    dec     cl
    and     cl, 0x03
    mov     ax, 0x0001
    shl     ax, cl
    xor     bx, ax

    ; send led command
    cli

    cdecl   KBC_Cmd_Write, 0xAD

    cdecl   KBC_Data_Write, 0xED
    cdecl   KBC_Data_Read, .key

    cmp     [.key], byte 0xFA
    jne     .11F

    cdecl	KBC_Data_Write, bx				;     // LEDデータ出力
												;   }
	jmp		.11E
.11F:
    cdecl   itoa, word [.key], .e1, 2, 16, 0b0100
    cdecl   puts, .e0
.11E:
    cdecl   KBC_Cmd_Write, 0xAE

    sti

    jmp     .10L
.10E:
    cdecl   puts, .s3

    jmp     stage_5

.s0:	db	"4th stage..", 0x0A, 0x0D, 0
.s1:    db  "A20 Gate Enable.", 0x0A, 0x0D, 0
.s2:    db  " Keyboard LED Test.. ", 0
.s3:    db  " (done) ", 0x0A, 0x0D, 0
.e0:    db  "["
.e1:    db  "ZZ]", 0
.key:   dw 0

stage_5:
    cdecl   puts, .s0

    cdecl   read_lba, BOOT, BOOT_SECT, KERNEL_SECT, BOOT_END
    cmp     ax, KERNEL_SECT
.10Q:
    jz      .10E
.10T:
    cdecl   puts, .e0
    call    reboot
.10E:

    jmp     stage_6

.s0:    db "5th stage..", 0x0A, 0x0D, 0
.e0:    db " Failure load kernel ....", 0x0A, 0x0D, 0

stage_6:
    cdecl   puts, .s0

.10L:
    mov     ah, 0x00
    int     0x16
    cmp     al, ' '
    jne     .10L

    mov     ax, 0x0012
    int     0x10

    jmp     stage_7

.s0:    db "6th stage..", 0x0A, 0x0D, 0x0A, 0x0D
.e0:    db " [Push SPACE key to protect mode...]", 0x0A, 0x0D, 0

; Glabal Discripter Table
ALIGN 4, db 0
GDT:    dq  0x00_0000_000000_0000   ; NULL
.cs:    dq  0x00_CF9A_000000_FFFF   ; Selector For Code
.ds:    dq  0x00_CF92_000000_FFFF   ; Selector For Data
.gdt_end:

; Glabal Discripter Table Register
GDTR:   dw  GDT.gdt_end - GDT - 1   ; GDT limit address
        dd  GDT                     ; GDT address

SEL_CODE    equ GDT.cs - GDT
SEL_DATA    equ GDT.ds - GDT

; Interrapt Discripter Table Register(dummy)
IDTR:   dw  0                       ; IDT limit
        dd  0                       ; IDT location

stage_7:
    cli

    lgdt    [GDTR]
    lidt    [IDTR]

    ; Set PE bit to migrate Protect mode.
    mov     eax, cr0
    or      ax, 1
    mov     cr0, eax

    jmp     $ + 2               ; look-ahead Clear

[BITS 32]
    DB      0x66
    jmp     SEL_CODE:CODE_32

CODE_32:
    ; init selector
    mov     ax, SEL_DATA
    mov     ds, ax
    mov     es, ax
    mov     fs, ax
    mov     gs, ax
    mov     ss, ax

    ; Copy kernel code
    mov     ecx, (KERNEL_SIZE) / 4
    mov     esi, BOOT_END
    mov     edi, KERNEL_LOAD
    cdl 
    rep movsd

    ; move kernel processing
    jmp     KERNEL_LOAD

; Padding (This file size should be 8K.)
    times   BOOT_SIZE - ($ - $$)     db 0

