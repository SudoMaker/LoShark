# LoShark Software

You can download prebuilt images from the "Releases" of this repo.

If you have any questions, open an issue or ask in our Discord server.


## Build

### rootfs
Please see [buildroot-loshark](https://github.com/SudoMaker/buildroot-loshark).

### initramfs
Copy the `initramfs-loshark-*.cpio` files to `/tmp`. They will be used when compiling the kernel.

**Binary files in the CPIO file**
- `/init` - https://github.com/SudoMaker/petitinit/
- `/jfs_fsck` - jfsutils

### Bootloader
Please see https://github.com/Ingenic-community/x-loader

### Linux kernel
Please see https://github.com/Ingenic-community/linux

- With RTC & PSRAM: `make ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- loshark_l1_v2.2_defconfig`
- Without RTC & PSRAM: `make ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- loshark_l1_v2.2_lite_defconfig`
- Customize your stuff as needed: `make ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- menuconfig`
- Build: `make ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- -j12 uImage`

### MBR partition table
- 256MB: `mbr-256M`
- 4GB: `mbr-4G`

### USB firmware update
- Download and extract the latest `cloner` from https://github.com/Ingenic-community/cloner
- Read the PDFs in `docs` in extracted directory if you're unfamiliar with this tool
- Copy `x1501_loshark_sfc_nor_lpddr_linux.cfg` to `configs/x1500/` in extracted directory
- If you're using Windows, make sure the USB drivers are installed
- Run `cloner`, and click on the `config` button
- Select `x1500` and `x1501_loshark_sfc_nor_lpddr_linux.cfg` in the `INFO` tab
- Select the firmware files in the `POLICY` tab by clicking on "..." buttons:
    - `boot_stage1`, `boot_stage2`, `kernel` are on the internal flash and. **They must be enabled or disabled at the same time.**
    - `mbr`, `rootfs`, `data` are on the SD NAND.
- Save the configuration by clicking on `OK`
- Click on the `Start` button
- Run `reboot-bootloader` in LoShark console, or hold button SW1 (BOOTSEL0) on the LoShark PCB and press SW2 (RESET) once.
