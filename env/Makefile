BOOT_PROGRAM_ROOT = ../src/00_boot_only
BOOT_PROGRAM = $(BOOT_PROGRAM_ROOT)/boot.s
ENV_ROOT = ../env


launch: launch-qemu launch-bochs 

launch-bochs: asem $(BOOT_PROGRAM_ROOT)/boot.img $(ENV_ROOT)/.bochsrc $(ENV_ROOT)/cmd.init
	bochs -q -f $(ENV_ROOT)/.bochsrc -rc $(ENV_ROOT)/cmd.init

launch-qemu: asem $(BOOT_PROGRAM_ROOT)/boot.img
        qemu-system-i386 -rtc base=localtime -drive file=$(BOOT_PROGRAM_ROOT)/boot.img,format=raw -boot order=c

asem: $(BOOT_PROGRAM)
	nasm $(BOOT_PROGRAM) -o $(BOOT_PROGRAM_ROOT)/boot.img -l $(BOOT_PROGRAM_ROOT)/boot.lst


