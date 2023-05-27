nasm -f bin ./main.asm -o main.bin
qemu-system-i386 -drive format=raw,file=./main.bin