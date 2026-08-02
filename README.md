# NetBoot for Quill OS on the PineNote

1. Install `dropbear`, `wget`, `lrzsz` and `nbdkit` on your host PC.
1. Extract your PineNote's waveform. On a default install, it can be fetched with `dd if=/dev/mmcblk0p2 of=ebc.wbf bs=512 status=progress`. Put `ebc.wbf` in the root of the `netboot-host` repository.
1. Run the `serve.sh` script (does not require root).
1. Get into your PineNote's U-Boot shell (you can access it with `sudo picocom /dev/tty.usbserial-10 -b 1500000`, for example) and enter:
    ```
    setenv bootargs "root=/dev/ram0 rootfstype=ramfs rdinit=/sbin/init earlycon console=ttyS2,1500000n8 fw_devlink=off vt.global_cursor_default=0 RUST_LOG=debug SLINT_KMS_ROTATION=270 SLINT_BACKEND_LINUXFB=1 quill_netboot=1"; echo Please provide Image.gz; loady 0x04080000; echo Please provide FDT; loady 0x0a100000; unzip 0x04080000 0x00a80000; booti 0x00a80000 - 0x0a100000
    ```
    Send `nbd/boot/Image.gz` and the `nbd/boot/DTB` via YMODEM when asked.
1. Wait until you see a message like this on the console:
    ```
    [2026-08-02T13:07:35Z INFO  libqinit::netboot] Waiting for NetBoot host; please connect USB cable
    ```
1. Plug your PineNote directly into your computer via USB cable.
1. Enjoy!
