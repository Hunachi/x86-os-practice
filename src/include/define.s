BOOT_LOAD   equ     0x7c00

BOOT_SIZE   equ     (1024 * 8)
SECT_SIZE   equ     (512)
BOOT_SECT   equ     (BOOT_SIZE / SECT_SIZE) ; Sector count of Boot program. 

E820_RECORD_SIZE    equ     20

KERNEL_LOAD equ     0x0010_1000
KERNEL_SIZE equ     (1024 * 8)