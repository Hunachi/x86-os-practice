basedir = $(shell pwd)
BOOT_PROGRAM = $(basedir)/boot.s
KERNEL_PROGRAM = $(basedir)/kernel.s
ENV_ROOT = $(basedir)/../../env

launch-bochs: assem boot.img
	bochs -q -f $(ENV_ROOT)/.bochsrc -rc $(ENV_ROOT)/cmd.init

assem: $(BOOT_PROGRAM)
	nasm $(BOOT_PROGRAM) -o boot.bin -l boot.lst
	nasm kernel.s -o kernel.bin -l kernel.lst
	cat boot.bin kernel.bin > boot.img
	cp $(basedir)/boot.img ../../env/boot.img
