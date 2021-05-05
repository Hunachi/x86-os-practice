; Syscalls

; Display 1 word
trap_gate1:
    ; ecx:character code
    ; ebx:character color
    ; ecx:row
    ; edx:column
    
    cdecl   draw_char, ecx, edx, ebx, eax
    iret

; Display a dot
trap_gate2:
    ; ebx:dot color
    ; ecx:X-coordinate
    ; edx:Y-coordinate

    cdecl   draw_pixel, ecx, edx, ebx
    iret
    
   