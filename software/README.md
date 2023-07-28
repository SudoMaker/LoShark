# LoShark Software

You can download prebuilt images from the "Releases" of this repo.

If you have any questions, open an issue or ask in our Discord server.

## rootfs
Please see [buildroot-2022.02.2-loshark](./buildroot-2022.02.2-loshark)

## Bootloader
Please see https://github.com/Ingenic-community/x-loader

## Linux kernel
Please see https://github.com/Ingenic-community/linux

- `make ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- menuconfig`
- Select `SudoMaker LoShark V2.2` in `Machine selection -> Machine type`
- Customize your stuff as needed
- `make ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- -j12 uImage`

## USB firmware update
- Download and extract the latest `cloner` from https://github.com/Ingenic-community/cloner
- Read the PDFs in `docs` in extracted directory if you're unfamiliar with this tool
- Copy `x1501_loshark_sfc_nor_lpddr_linux.cfg` to `configs/x1500/` in extracted directory
- If you're using Windows, make sure the USB drivers are installed
- Run `cloner`, and click on the `config` button
- Select `x1500` and `x1501_loshark_sfc_nor_lpddr_linux.cfg` in the `INFO` tab
- Select the firmware files in the `POLICY` tab. `boot_stage1`, `boot_stage2`, `kernel` are on the internal flash and must be enabled or disabled at the same time. `mmc1` is the SD NAND.
- Save the configuration by clicking on `OK`
- Click on the `Start` button
- Hold button SW1 on the LoShark PCB and connect it to your computer
