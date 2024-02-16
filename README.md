# LoShark

Next-gen USB LoRa debug tool. Runs mainline Linux on itself. Versatile JavaScript ES2015 interface allows access to every SX126x chip register easily. Up to 4GB flash storage allows long-time data collection. Works with any modern PC.

## [Interactive Dashboard](https://su.mk/loshark-app)

![image](https://github.com/SudoMaker/LoShark/assets/34613827/6e42656b-3d51-45db-9529-d6e84b04e2d3)

![EE4A1247](https://github.com/SudoMaker/LoShark/assets/34613827/04a7e128-ff37-4aed-a8a6-8f529c628fe5)

Hackaday link: https://hackaday.io/project/192129-loshark

Hackster link: https://www.hackster.io/reimunotmoe/loshark-1069d0

Buy it in our store: https://shop.sudomaker.com/products/loshark-l1

## Contents

- Hardware: PDFs of schematic and component placement on the PCB
- Software: rootfs, Linux kernel, bootloader and USB firmware update

## Usage

### Booting
Connect LoShark to your PC (or a power bank, if you have loaded your program inside it).

The LED shows the boot progress:
- RED: kernel is booted and `/init` in initramfs started running
- Yellow: rootfs is fscked & mounted successfully and `/sbin/init` started running

### Connecting to LoShark's serial console
PuTTY is the recommended software. But you can use anything you like.

Baud rate is ignored since this is USB CDC ACM.

**Default Login information**

Username: `root`

Password: `loshark`

Changing password requires the rootfs to be mounted read-write (see below).

### Autostart
When the LoShark is finished booting, the script `/data/app/app.sh` will be executed.

This is programmed to launch the Resonance runtime by default. You can edit it to suit your needs.

### Resonance REPL console
Use the command `app-console` to attach to the console. Use `Ctrl-\` to detach.

Only use `Ctrl-C` if you want to terminate the Resonance runtime.

### JavaScript Example
```javascript
const {SX126x} = loadModule("loshark/sx126x");
const {GPIOControllerLinux} = loadModule("gpio/linux");
const {SPIControllerLinux} = loadModule("spi/linux");

const gpioa = new GPIOControllerLinux(0);
const pa19 = gpioa.open(19, "SX126x NRST");
const pa18 = gpioa.open(18, "SX126x BUSY");
const pa17 = gpioa.open(17, "SX126x DIO1");
const pa16 = gpioa.open(16, "SX126x DIO2");

const spi0 = new SPIControllerLinux(0);
const spidev0_0 = spi0.open(0);

const cfg = {
  chip: "SX1262", // "SX1268" if you have the 433 (410-510 MHz) version
  tcxo: { voltage: 0x2, timeout: 32 },
  gpio: { reset: pa19, busy: pa18, dio1: pa17, dio2: pa16 },
  spi: spidev0_0,
};

mdm = new SX126x(cfg);

mdm.on("receive", msg => console.log("packet received:", msg));
mdm.on("receive", () => {pkt_cnt++; console.log("pkt cnt:", pkt_cnt);});
mdm.on("signal", sig => console.log("signal:", sig));
mdm.on("event", ev => console.log("event:", ev));

mdm.open().then(() => {
    console.log("modem opened");
    mdm.setProp("sx126x.lora.crc", false);
    mdm.setProp("sx126x.lora.sf", 12);
    mdm.setProp("sx126x.lora.bw", 250);
    mdm.setProp("sx126x.lora.cr", "1/1");
    mdm.setProp("sx126x.lora.ldro", true);
    mdm.setProp("sx126x.lora.preamble_len", 12);
    mdm.setProp("modem0.rf.tx_power", 22);
});

mdm.listProp().then(console.log);

mdm.getProp("sx126x.rssi_inst").then(val => {console.log("RSSI:", val);});

mdm.transmit('cafebcafebcafebcafebcafebcafebcafebcafebcafeb').then(console.log);

```

### Making rootfs read-write
`mount / -wo remount`

Run `sync` to ensure your changes are written to the flash.

### Setting date/time
Use the `TZ` environment variable or the `/etc/TZ` file to set the timezone. Only the `UTC+X` format is supported.

Also read this article: https://unix.stackexchange.com/questions/104088/why-does-tz-utc-8-produce-dates-that-are-utc8

Use `date` to set the system time.

Use `hwclock -u -w` to sync system time to RTC.

If you're using a Linux PC, use this one liner to sync your PC time to LoShark:

```
echo 'date -u -s @'`date +%s` > /dev/ttyACMx
```

Here `ttyACMx` is the LoShark terminal you're currently logged in.

### Transferring files
The MTP protocol is implemented.

You probably need to use some 3rdparty software if you use MacOS.

For advanced users: The `lrzsz` package is also installed.

**Run `sync` in the LoShark console to ensure your changes are written to the flash.**

### Resizing data partition on 4GB devices
The data partition image is suitable for the 256MB version. If you have the 4GB version, run `mount /data -o remount,resize` on LoShark to resize it to maximum size after flashing this partition.

## Notes
If you have any questions, feel free to open an issue or ask in our Discord server.
