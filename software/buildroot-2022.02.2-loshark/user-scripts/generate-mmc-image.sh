#!/bin/bash

[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

if [ -z "output/images/rootfs.tar" ]; then
	echo "Please run this script in the root directory of buildroot."
	exit 2
fi

if [ -e "mmc.img" ]; then
	echo "mmc.img already exists, please remove it manually."
	exit 2
fi

fallocate -l 251658240 mmc.img || exit 2
echo -ne '\no\nn\np\n1\n2048\n100351\nn\np\n2\n100352\n491519\nw\n'|fdisk mmc.img || exit 2

LOOPDEV=`losetup -f`

if [ -z "$LOOPDEV" ]; then
	echo -ne 'No usable loop device'
	exit 2
fi

losetup -P "$LOOPDEV" mmc.img || exit 2

echo y|mkfs.jfs "$LOOPDEV"p1 || exit 2
echo y|mkfs.jfs "$LOOPDEV"p2 || exit 2

TMPDIR=`mktemp -d`

mount "$LOOPDEV"p1 "$TMPDIR" || exit 2

tar -C "$TMPDIR" -xvf "output/images/rootfs.tar" || exit 2

df -h "$TMPDIR"

umount "$TMPDIR" || exit 2

rmdir "$TMPDIR" || exit 2

losetup -d "$LOOPDEV" || exit 2

exit 0