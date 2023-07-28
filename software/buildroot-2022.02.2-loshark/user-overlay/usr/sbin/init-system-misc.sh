#!/bin/sh

chrt -p 50 `pgrep spi0` -f

sysctl -w vm.dirty_expire_centisecs=1000
sysctl -w vm.min_free_kbytes=64

exit 0
