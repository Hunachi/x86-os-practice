; Reference: 作って理解するOS x86系コンピュータを動かす理論と実装 (https://gihyo.jp/book/2019/978-4-297-10847-2)

jmp	$	;while(1)

times	510-($-$$) db 0x00
db	0x55, 0xAA
