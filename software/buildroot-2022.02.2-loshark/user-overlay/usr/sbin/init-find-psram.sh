#!/bin/sh

mkdir -p /dev/block

cat /sys/bus/spi/drivers/lyontek_ly68/*/mtd/mtd?/mtdblock?/dev| while read majmin; do
	majmin_spaced=`echo $majmin | sed s/:/' '/g`
	mknod /dev/block/psram-"$majmin" b $majmin_spaced
done

exit 0
