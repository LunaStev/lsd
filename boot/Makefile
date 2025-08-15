TARGET = BOOTX64.EFI
SRC = bootloader.c
OBJ = bootloader.o
GNU_EFI_DIR = /usr/lib
INCLUDE_DIR = /usr/include/efi
ARCH = x86_64

CFLAGS = -fno-stack-protector -fpic -fshort-wchar -mno-red-zone \
         -I$(INCLUDE_DIR) -I$(INCLUDE_DIR)/$(ARCH) \
         -DEFI_FUNCTION_WRAPPER

LDFLAGS = -nostdlib -znocombreloc \
          -T $(GNU_EFI_DIR)/elf_$(ARCH)_efi.lds \
          $(GNU_EFI_DIR)/crt0-efi-$(ARCH).o \
          -L $(GNU_EFI_DIR)/$(ARCH) -lefi -lgnuefi

OBJCOPY_FLAGS = -j .text -j .sdata -j .data -j .dynamic \
                -j .dynsym -j .rel -j .rela -j .reloc \
                --target=efi-app-$(ARCH)

all: $(TARGET)

$(TARGET): $(OBJ)
	ld $(LDFLAGS) $(OBJ) -o bootloader.so
	objcopy $(OBJCOPY_FLAGS) bootloader.so $(TARGET)

%.o: %.c
	gcc $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) bootloader.so $(TARGET)
