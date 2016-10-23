
# GalileoTinycore
Running Tinycore on an Intel Galileo Board (Quark)

## Description

This project wants to run Tinycore Linux on top of an Intel Galileo Board. The Galileo board has an single core Intel Quark CPU (x86). Intel provides a BSP based on the yocto project for it.
The goal of this project is to run a simpler linux distro without the need to compile the whole yocto project for it.
Tinycore is distributed for different platforms. This project uses the x86 distribution.

## Requirements

You will need a microSD card to hold the distro.
Also you will need to communicate with the Galileo Board using a UART interface. 

## Getting Started

The microSD card will need to be partitioned. The first partition (mmcblk0p1) will be FAT32. It will only hold the grub.efi binary and the grub config file, therefore a couple of megabytes will be more than enough.
The second partition (mmcblk0p2) will hold the kernel, initramfs, home directory for tc user and the tinycore extensions (TCZs).
Use a linux filesystem like Ext3. There is no limit in size.
If you are using linux I suggest using gparted. Create a new partition table (msdos), and create both partitions.

## Modifying the Tinycore Initramfs (core.gz)

Follow the instructions on initramfs/README. Since we communicate with the Galileo Board using UART, the inittab has to be changed to autologin on /dev/ttyS1 instead of /dev/tty1. Make sure you get rid of the tinycore built-in kernel modules distributed with tinycore since we are compiling our own kernel.

## Compiling the kernel

Follow the instructions on kernel/README. The kernel is the same version used by the Intel BSP and the Yocto Project. The kernel-config file has the requirements to mount tinycore extensions (SquashFS) and to mount the home as ext3. 
Tinycore generates a set of kernel-extensions so the kernel modules are not all built into the initramfs. This saves RAM since the kernel extensions are mounted on TCZs. For simplicity this project puts all the kernel modules into the initramfs.

## Preparing the microSD card

Once the kernel is compiled and the kernel modules are placed into the initramfs, you need to copy the files into the microSD card as listed below.

The FAT32 partition (mmcblk0p1) will have:

    |
    |- grub.efi
    |- boot/
        |- grub/
            |- grub.conf 

The EXT3 partition (mmcblk0p2) will have:

    |
    |- bzImage
    |- core.gz
    |- tce/
        |- onboot.lst
        |- optional/

After the first boot, tinycore will create /home/tc on mmcblk0p2 to hold tc user home.
Any TCZ installed using tce-load -wi XXXXXXX.tcz will end up in tce/optional so it will persist after a reboot.

## Running Tinycore on Galileo

Simply insert the microSD card on the Galileo Board microSD slot. Connect to the board using a serial terminal. After turning it on, Grub will start and will load the kernel into memory and mount the initramfs. At this point Tinycore will start and will leave you on a prompt.

You can use the ethernet port (DHCP) to install TCZs simply doing tce-load -wi XXXXXXX.tcz

## Using USB device port
You can now connect a USB cable on the client port, and avoid using a USB-Serial interface. The board will output a terminal using g_serial on the USB port. The driver for Windows can be downloaded from Intel site. Mac requires no driver.

## Thanks

Thanks to Tinycore members for creating such a great distro.
Thanks to Intel for donating Galileo Boards to Universities in Argentina.
Thanks to UNLaM (www.unlam.edu.ar) for the support.
