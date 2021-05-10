
		;---------------------------------------
		;           |            | 
		;           |____________| 
		; 0000_7A00 |            | ( 512) スタック
		;           |____________| 
		; 0000_7C00 |            | (  8K) ブート
		;           =            = 
		;           |____________| 
		; 0000_9C00 |            | (  8K) カーネル（一時展開）
		;           =            = 
		;           |____________| 
		; 0000_BC00 |////////////| 
		;           =            = 
		;           |____________| 
		; 0010_0000 |       (2K) | 割り込みディスクリプタテーブル
		;           |____________| 
		; 0010_0800 |       (2K) | カーネルスタック
		;           |____________| 
		; 0010_1000 |       (8K) | カーネルプログラム
		;           |            | 
		;           =            = 
		;           |____________| 
		; 0010_3000 |       (8K) | タスク用スタック
		;           |            | （各タスク1K）
		;           =            = 
		;           |____________| 
		; 0010_5000 |            | Dir
		;      6000 |____________| Page
		; 0010_7000 |            | Dir
		;      8000 |____________| Page
		; 0010_9000 |////////////| 
		;           |            | 


BOOT_LOAD   equ     0x7C00
KERNEL_LOAD equ     0x0010_1000

BOOT_SIZE   equ     (1024 * 8)
SECT_SIZE   equ     (512)
KERNEL_SIZE equ     (1024 * 8)

BOOT_SECT   equ     (BOOT_SIZE / SECT_SIZE)  ; Sector count of Boot program. 
KERNEL_SECT equ     (KERNEL_SIZE / SECT_SIZE)

E820_RECORD_SIZE    equ     20

BOOT_END    equ    (BOOT_LOAD + BOOT_SIZE)

VECT_BASE   equ     0x0010_0000

STACK_BASE  equ     0x0010_3000
STACK_SIZE  equ     1024

SP_TASK_0   equ     STACK_BASE + (STACK_SIZE * 1)
SP_TASK_1   equ     STACK_BASE + (STACK_SIZE * 2)
SP_TASK_2   equ     STACK_BASE + (STACK_SIZE * 3)
SP_TASK_3   equ     STACK_BASE + (STACK_SIZE * 4)

CR3_BASE 	equ 	0x0010_5000	; Page table's base