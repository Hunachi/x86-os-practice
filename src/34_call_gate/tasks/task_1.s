task_1:
	
	cdecl	SS_GATE_0:0, 63, 0, 0x07, .s0		; draw_str();

.10L:
	; Display time
	; mov     eax, [RTC_TIME]                 ; Get time
	; cdecl	draw_time, 72, 0, 0x0700, eax   ; display time
	
	; jmp 	SS_TASK_0:0

	jmp		.10L

.s0		db	"Task-1", 0

