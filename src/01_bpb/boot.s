; Reference: 作って理解するOS x86系コンピュータを動かす理論と実装 (https://gihyo.jp/book/2019/978-4-297-10847-2)

; *****************
;    Entory Point 
; *****************
entry:
    jmp     ipl
    
    ; BPB(BOPS Parameter Block)
    times    90-($-$$) db 0x90
    ; IPL(Initial Program Loader)
ipl:
    ; End process
    jmp     $   ; while(1);

    times    510-($-$$) db 0x00
    db      0x55, 0xAA

