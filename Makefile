gcc -fno-stack-protector -fpic -fshort-wchar -mno-red-zone \
    -I/usr/include/efi -I/usr/include/efi/x86_64 \
    -c bootloader.c -o bootloader.o

ld -nostdlib -znocombreloc -T /usr/lib/elf_x86_64_efi.lds \
    /usr/lib/crt0-efi-x86_64.o bootloader.o \
    -o bootloader.so -L/usr/lib -lefi -lgnuefi

objcopy -j .text -j .sdata -j .data -j .dynamic \
    -j .dynsym -j .rel -j .rela -j .reloc \
    --target=efi-app-x86_64 bootloader.so BOOTX64.EFI
