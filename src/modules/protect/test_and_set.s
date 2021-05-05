; test and set for exclusive control 
test_and_set:
    ; global address
    
    push    ebp 
    mov     ebp, esp

    push    eax
    push    ebx

    ; test and set
    mov     eax, 0
    mov     ebx, [ebp + 8]  ; global address

.10L:
    lock bts [ebx], eax	    ; cf = TEST_AND_SET(ebx, 1)
    jnc     .10E
.12L:
    bt      [ebx], eax      ; cf = TEST(ebx, 1)
    jc      .12L            ; wait while cp == 0

    jmp    .10L
.10E:

    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp

    ret
