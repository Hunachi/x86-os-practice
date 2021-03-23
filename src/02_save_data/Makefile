BOOT_PROGRAM = boot.s
ENV_ROOT = ../../env


launch-bochs: asem boot.img $(ENV_ROOT)/.bochsrc $(ENV_ROOT)/cmd.init
	bochs -q -f $(ENV_ROOT)/.bochsrc -rc $(ENV_ROOT)/cmd.init

launch-qemu: asem boot.img
        qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c

asem: $(BOOT_PROGRAM)
	nasm $(BOOT_PROGRAM) -o boot.img -l boot.lst

