BOOT_PROGRAM = boot.s
ENV_ROOT = ../../env


launch-qemu: asem boot.img
        qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c

asem: $(BOOT_PROGRAM)
	nasm $(BOOT_PROGRAM) -o boot.img -l boot.lst

