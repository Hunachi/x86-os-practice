; Detect [CTRL+ALT+Return]
; This function return not zero if [CTRL+ALT+Return] are pushed.
ctrl_alt_return:

    push    ebp
    mov     ebp, esp
    
    ; Save a key status.
    mov     eax, [ebp + 8]
    btr     eax, 7
    jc      .10F
    bts     [.key_state], eax   ; Set flag
    jmp     .10E
.10F:
    btc     [.key_state], eax   ; Clear flag
.10E:

    ; Judge that keys are pushed.
    mov     eax, 0x1D   ; Ctrl
    bt      [.key_state], eax
    jnc     .20E
    
    mov     eax, 0x38   ; Alt
    bt      [.key_state], eax
    jnc     .20E

    mov     eax, 0x1C   ; Return
    bt      [.key_state], eax
    jnc     .20E

    mov     eax, -1
.20E:
    sar     eax, 8

    mov     esp, ebp
    pop     ebp

    ret

.key_state: times   32  db  0
