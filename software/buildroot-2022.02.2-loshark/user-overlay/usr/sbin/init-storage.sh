#!/bin/sh

umount /mnt

init-find-psram.sh
init-crypt-psram-swap.sh

fsck.jfs /dev/mmcblk0p2

mount /dev/mmcblk0p2 /data || exit 2
mkdir -p /data/home
mkdir -p /data/app
mount --bind /data/home /root/

exit 0
