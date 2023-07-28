#!/bin/sh

TD="$1"

cd "$TD"/

echo "-- 00 - Disable useless services"

mkdir -p etc/init.d/disabled
mv -v etc/init.d/*logd* etc/init.d/disabled

mv -v etc/init.d/*rngd* etc/init.d/disabled

exit 0
