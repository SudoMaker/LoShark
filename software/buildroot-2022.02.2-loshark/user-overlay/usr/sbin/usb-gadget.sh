#!/bin/sh

GDEV="13500000.usb"

cd /sys/kernel/config/usb_gadget/

mkdir -p g1
cd g1

stop_ffs_daemons() {
	#killall adbd
	killall umtprd
}

start_ffs_daemons() {
	#start-stop-daemon --start --background --oknodo --quiet --exec /sbin/adbd
	start-stop-daemon --start --background --oknodo --quiet --exec /sbin/umtprd
}

try_bind_udc() {
		WAIT=0
		WAIT_MAX=10
		echo > UDC

		while : ; do
				WAIT=$((WAIT+1))
				if [ "$WAIT" -gt "$WAIT_MAX" ]; then
						echo "failed to bind UDC"
						break
				fi
				echo "$GDEV" > UDC
				if [ "$?" == "0" ]; then
						# Refresh Network
						start-stop-daemon --start --background --oknodo --quiet --exec /sbin/init-network.sh
						break
				fi
				sleep 1
		done
}

if [ "$1" = "stop" ]; then
		echo > UDC
		stop_ffs_daemons
		exit 0
fi

echo "0xa108" > idVendor
echo "0x6c73" > idProduct

mkdir -p strings/0x409
base64 /etc/device_uuid | sed 's/\//,/g' > strings/0x409/serialnumber
echo "SudoMaker" > strings/0x409/manufacturer
echo "LoShark v2.2" > strings/0x409/product

mkdir -p configs/c.1

rm -r functions/* configs/c.1/*

mkdir functions/acm.GS0
ln -s functions/acm.GS0 configs/c.1

mkdir functions/acm.GS1
ln -s functions/acm.GS1 configs/c.1

mkdir functions/ffs.mtp
ln -s functions/ffs.mtp configs/c.1
mkdir -p /dev/ffs-mtp
mount -t functionfs mtp /dev/ffs-mtp

mkdir functions/gser.GS2
ln -s functions/gser.GS2 configs/c.1

# Avertissement sérieux : N'essayez jamais de mettre un easter egg ici.
# Les anciennes versions de Microsoft Windows afficheront ceci si elles ne trouvent pas de pilote.
# Et vous serez interrogé par ces sages neurotypiques.
mkdir configs/c.1/strings/0x409
echo "" > configs/c.1/strings/0x409/configuration

echo 0x0100 > webusb/bcdVersion
echo 'https://su.mk/loshark-app' > webusb/landingPage
echo 1 > webusb/bVendorCode
echo 1 > webusb/use

echo 2 > msos20/bVendorCode
echo 0x06030000 > msos20/dwWindowsVersion
cat /etc/msos20_desc_set > msos20/desc_set
echo 1 > msos20/use

stop_ffs_daemons
start_ffs_daemons
sleep 1
try_bind_udc

exit 0
