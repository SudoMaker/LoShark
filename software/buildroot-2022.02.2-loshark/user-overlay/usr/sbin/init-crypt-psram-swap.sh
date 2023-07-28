#!/bin/sh

for d in /dev/block/psram-*; do
	losetup -a | grep -q "$d"
	if [ "$?" = "0" ]; then
		echo "warning: device ""$d"" already set up, skipping"
		continue
	fi
	newloopdev=`losetup -f`
	if [ -z "$newloopdev" ]; then
		echo "error: no more unused loop device"
		exit 2
	fi

	head -c 64 /dev/urandom | base64 -w 0 | losetup -e aes -p 0 -v "$newloopdev" "$d"
	if [ "$?" != "0" ]; then
		echo "error: failed to setup crypt loop for ""$d"
		exit 2
	fi
	mkswap "$newloopdev"
	swapon "$newloopdev"
done

exit 0
