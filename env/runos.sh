#!/bin/zsh

if [ -e kernel.s ]; then
  nasm boot.s -o boot.bin -l boot.lst
  nasm kernel.s -o kernel.bin -l kernel.lst
  cat boot.bin kernel.bin > boot.img
else
  nasm boot.s -o boot.img -l boot.lst
fi

rm boot.bin kernel.bin kernel.lst boot.lst

bochs -q -f ../../env/.bochsrc -rc ../../env/cmd.init

rm boot.img