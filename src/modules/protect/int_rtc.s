; Create RTC interrupt
int_rtc:

    pusha
    push    ds
    push    es

    mov     ax, 0x0010
    mov     ds, ax
    mov     es, ax

    ; Get time from RTC
    cdecl   rtc_get_time, RTC_TIME

    ; Get reason of RTC interrupt
    outp    0x70, 0x0C  ; get and clear data 
    in      al, 0x71

    ; Clear interrupt
    mov     al, 0x20    ; EOI command
    out     0x0A, al    ; to master
    out     0x20, al    ; to slave

    pop     es
    pop     ds
    popa

    iret

; Enable RTC's UIE(Update-ended Interrupt Enable)
rtc_int_en:
    push    ebp
    mov     ebp, esp

    push    eax

    ; Setting
    outp    0x70, 0x0B

    in      al, 0x71
    or      al, [ebp + 8]

    out     0x71, al

    pop     eax

    mov     esp, ebp
    pop     ebp

    ret 

