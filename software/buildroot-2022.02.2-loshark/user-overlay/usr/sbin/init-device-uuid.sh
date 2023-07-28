#!/bin/sh

UUID_FILE_PATH="/etc/device_uuid"

if [ ! -e "$UUID_FILE_PATH" ]; then
	mount / -wo remount
	head -c 16 /dev/urandom > "$UUID_FILE_PATH"
	mount / -ro remount
	sync
fi

exit 0
