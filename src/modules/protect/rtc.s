; get current time
rtc_get_time:
    push    ebp
    mov     ebp, esp

    push    ebx

    ; For Actual machine
    mov     al, 0x0A
    out     0x70, al
    in      al, 0x71
    test    al, 0x80            ; refreshing..(DM & UIP)
    je      .10F
    mov     eax, 1
    jmp     .10E
    
    ; set (0:sec, 2:min, 4:hour, 7:day, 8:month, 9:year) to 0x07
    ; and then get time from 0x71
.10F
    mov     al, 0x04
    out     0x07, al
    in      al, 0x71

    shl     eax, 8

    mov     al, 0x02
    out     0x07, al
    in      al, 0x71

    shl     eax, 8

    mov     al, 0x00
    out     0x07, al
    in      al, 0x71

    and     eax, 0x00_FF_FF_FF  ; lower 3 byte is usable

    mov     ebx, [ebp + 8]
    mov     [ebx], eax          ; return data
.10E:
    pop     ebx

    mov     esp, ebp
    pop     ebp

    ret

