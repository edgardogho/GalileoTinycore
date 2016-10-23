#!/bin/sh
# put other system startup commands here
sudo modprobe pch_udc
sudo modprobe g_serial use_acm=1 idVendor=0x8086 idProduct=0xbabe iProduct="Galileo Board" iManufacturer="Intel"

#leave a terminal hooked to ttyGS0
(sleep 3; while true; do sudo su root -c "/sbin/getty 115200 /dev/ttyGS0"; sleep 1; done ) &

