#!/bin/zsh

debug=$1

if [ -e kernel.s ]; then
  nasm boot.s -o boot.bin -l boot.lst
  nasm kernel.s -o kernel.bin -l kernel.lst
  cat boot.bin kernel.bin > boot.img
else
  nasm boot.s -o boot.img -l boot.lst
fi

if [ ! -z "$debug" ] && [ "$debug" = "debug" ]; then 
  echo "debug"
else 
  echo "not debug"
  rm boot.bin kernel.bin kernel.lst boot.lst
fi

bochs -q -f ../../env/.bochsrc -rc ../../env/cmd.init;
