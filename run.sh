#!/bin/sh

set -e

nasm tic.asm -f bin -o boot.bin
qemu-system-x86_64 boot.bin
