# Buildroot for LoShark

## Usage
- Make sure you have at least 10GB disk space and a good Internet connection
- Download [buildroot-2022.02.2](https://buildroot.org/downloads/buildroot-2022.02.2.tar.xz) and extract it
- Copy everything in this folder (`cp -av ./* ./.* destdir/`) to the buildroot folder you just extracted
- Install dependencies for your distro according to buildroot's tutorials
- `cd` into the buildroot folder and `make`
- It will take like 30min-2h depending on your Internet speed and PC performance
- Run `./user-scripts/generate-mmc-image.sh` to generate the SD NAND image

## Binary files
The `user-overlay` directory contains some prebuilt binary files for convenience.

However you can build them by yourself if you absolutely want to do that.

- `ingenic_gpio`: https://github.com/Ingenic-community/IngenicHAL/blob/main/utils/ingenic_gpio.c
- `dtachez`: https://github.com/SudoMaker/dtachez
- `jfs_fsck`: jfsutils
- `path-exist-poller`: A very short C program, see notes

## Notes
This folder contains files whose names are starting with a dot and symlinks.

Program source of `path-exist-poller`:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv) {
	if (argc < 4) {
		puts("Usage: $0 <poll every N seconds> <path that should exist> <script or command>");
		puts("Example: $0 2 /sys/bus/gadget/drivers/configfs-gadget.g1 /sbin/usb-gadget.sh");
		exit(1);
	}

	long poll_time = strtol(argv[1], NULL, 10);

	while (1) {
		if (access(argv[2], F_OK)) {
			system(argv[3]);
		}

		sleep(poll_time);
	}
}
```