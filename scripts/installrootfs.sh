#!/bin/bash

echo "Installing root fs..."
umount /dev/sdX1
umount /dev/sdX2
sudo mkfs.ext4 -i 1024 -L rootfs /dev/sdX2
sudo mount /dev/sdX2 /mnt
cd /mnt
sudo tar xvf $1/rootfs.tar
cd $1
sudo umount /dev/sdX2

echo "Installing kernel..."
sudo mount /dev/sdX1 /mnt
sudo cp $1/zImage /mnt/kernel.img
sudo cp $1/zImage /mnt/kernel7.img
sudo umount /dev/sdX1
