wget http://192.168.56.1:2000/boot.asm -O ./boot.asm
clear
nasm -f bin ./boot.asm -o ./boot.bin
qemu-system-x86_64 -hda ./boot.bin
