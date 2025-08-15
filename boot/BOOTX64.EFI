#include <efi.h>
#include <efilib.h>

#define KERNEL_PATH L"\\boot\\kernel.bin"
#define KERNEL_LOAD_ADDR ((void*)0x100000)

EFI_STATUS EFIAPI efi_main(EFI_HANDLE image, EFI_SYSTEM_TABLE *st) {
    InitializeLib(image, st);
    st->ImageHandle = image;

    Print(L"[BOOT] Fixed Kernel Bootloader\n");

    EFI_LOADED_IMAGE *loaded_image;
    uefi_call_wrapper(st->BootServices->HandleProtocol, 3,
        image, &gEfiLoadedImageProtocolGuid, (void**)&loaded_image);

    EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *fs;
    uefi_call_wrapper(st->BootServices->HandleProtocol, 3,
        loaded_image->DeviceHandle, &gEfiSimpleFileSystemProtocolGuid, (void**)&fs);

    EFI_FILE *root;
    fs->OpenVolume(fs, &root);

    EFI_FILE *kernel_file;
    if (root->Open(root, &kernel_file, KERNEL_PATH, EFI_FILE_MODE_READ, 0) != EFI_SUCCESS) {
        Print(L"ERROR: %s not found!\n", KERNEL_PATH);
        goto fail;
    }

    EFI_FILE_INFO *info;
    UINTN info_size = sizeof(EFI_FILE_INFO) + 200;
    st->BootServices->AllocatePool(EfiLoaderData, info_size, (void**)&info);
    kernel_file->GetInfo(kernel_file, &gEfiFileInfoGuid, &info_size, info);

    UINTN size = info->FileSize;
    kernel_file->Read(kernel_file, &size, KERNEL_LOAD_ADDR);
    kernel_file->Close(kernel_file);

    Print(L"[BOOT] Kernel loaded at %p (%u bytes)\n", KERNEL_LOAD_ADDR, (unsigned)size);

    UINTN map_size = 0, map_key, desc_size;
    UINT32 desc_ver;
    st->BootServices->GetMemoryMap(&map_size, NULL, &map_key, &desc_size, &desc_ver);
    void *map_buf;
    st->BootServices->AllocatePool(EfiLoaderData, map_size, &map_buf);
    st->BootServices->GetMemoryMap(&map_size, map_buf, &map_key, &desc_size, &desc_ver);
    st->BootServices->ExitBootServices(image, map_key);

    void (*kernel_entry)(void) = (void(*)(void))KERNEL_LOAD_ADDR;
    kernel_entry();

fail:
    st->RuntimeServices->ResetSystem(EfiResetShutdown, EFI_SUCCESS, 0, NULL);
    return EFI_SUCCESS;
}
