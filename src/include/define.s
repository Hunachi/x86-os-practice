BOOT_LOAD   equ     0x7c00
KERNEL_LOAD equ     0x0010_1000

BOOT_SIZE   equ     (1024 * 8)
SECT_SIZE   equ     (512)
KERNEL_SIZE equ     (1024 * 8)

BOOT_SECT   equ     (BOOT_SIZE / SECT_SIZE)  ; Sector count of Boot program. 
KERNEL_SECT equ     (KERNEL_SIZE / SECT_SIZE)

E820_RECORD_SIZE    equ     20

BOOT_END     equ    (BOOT_LOAD + BOOT_SIZE)
