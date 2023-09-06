# LoShark Software

You can download prebuilt images from the "Releases" of this repo.

If you have any questions, open an issue or ask in our Discord server.

## Usage

### Connecting to LoShark's serial console
PuTTY is the recommended software. But you can use anything you like.

Baud rate is ignored since this is USB CDC ACM.

**Default Login information**

Username: `root`

Password: `loshark`

### Resonance REPL console
Use the command `app-console` to attach to the console. Use `Ctrl-\` to detach.

Only use `Ctrl-C` if you want to terminate the Resonance runtime.

### Making rootfs read-write
`mount / -wo remount`

Run `sync` to ensure your changes are written to the flash.

### Setting date/time
Use the `TZ` environment variable or the `/etc/TZ` file to set the timezone. Only the `UTC+X` format is supported.

Also read this article: https://unix.stackexchange.com/questions/104088/why-does-tz-utc-8-produce-dates-that-are-utc8

Use `date` to set the system time.

Use `hwclock -u -w` to sync system time to RTC.

If you're using a Linux PC, use this one liner to sync your PC time to LoShark:

```
echo 'date -u -s @'`date +%s` > /dev/ttyACMx
```

Here `ttyACMx` is the LoShark terminal you're currently logged in.

### Transferring files
The MTP protocol is implemented.

You probably need to use some 3rdparty software if you use MacOS.

For advanced users: The `lrzsz` package is also installed.

**Run `sync` in the LoShark console to ensure your changes are written to the flash.**

### Resizing data partition on 4GB devices
The data partition image is suitable for the 256MB version. If you have the 4GB version, run `mount /data -o remount,resize` to resize it to maximum size.

## Build

### rootfs
Please see [buildroot-2022.02.2-loshark](./buildroot-2022.02.2-loshark)

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

### USB firmware update
- Download and extract the latest `cloner` from https://github.com/Ingenic-community/cloner
- Read the PDFs in `docs` in extracted directory if you're unfamiliar with this tool
- Copy `x1501_loshark_sfc_nor_lpddr_linux.cfg` to `configs/x1500/` in extracted directory
- If you're using Windows, make sure the USB drivers are installed
- Run `cloner`, and click on the `config` button
- Select `x1500` and `x1501_loshark_sfc_nor_lpddr_linux.cfg` in the `INFO` tab
- Select the firmware files in the `POLICY` tab:
    - `boot_stage1`, `boot_stage2`, `kernel` are on the internal flash and must be enabled or disabled at the same time.
    - `mbr`, `rootfs`, `data` are on the SD NAND.
- Save the configuration by clicking on `OK`
- Click on the `Start` button
- Run `reboot-bootloader` in LoShark console, or hold button SW1 (BOOTSEL0) on the LoShark PCB and press SW2 (RESET) once.
