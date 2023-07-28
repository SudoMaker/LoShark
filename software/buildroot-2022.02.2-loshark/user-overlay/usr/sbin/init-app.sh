#!/bin/sh

pgrep -f 'dtachez -n /tmp/.dt_app' > /dev/null
if [ "$?" = "0" ]; then
	echo "App is already running."
	exit 1
fi

if [ -e "/data/app/app.sh" ]; then
	echo "Starting app..."
	cd /data/app
	dtachez -n /tmp/.dt_app sh ./app.sh
else
	echo "App not found. Please place your start script at /data/app/app.sh"
fi

exit 0
