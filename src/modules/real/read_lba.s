read_lba:
    push    bp 
    mov     bp, sp

    push    si

    mov     si, [bp + 4] ; si = drive info

    ; Converte lba -> chs
    mov     ax, [bp + 6]
    cdecl   lba_chs, si, .chs, ax

    ; Copy drive number
    mov     al, [si + drive.no]
    mov     [.chs + drive.no], al

    ; Read sector to ax
    cdecl   read_chs, .chs, word [bp + 8], word [bp + 10]

    pop     si

    mov     sp, bp
    pop     bp

    ret

ALIGN 2
.chs:
    times   drive_size  db 0
