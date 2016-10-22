#!/bin/sh
# put other system startup commands here

#Load module for g_serial (virtual serial port over USB)
sudo modprobe pch_udc
sudo modprobe g_serial use_acm=1
#Now force a terminal on the virtual serial port
(sleep 5; sudo su root -c "/sbin/getty 115200 /dev/ttyGS0") &
