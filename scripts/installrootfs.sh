#!/bin/bash

echo "Installing root fs..."
umount /dev/sdc1
umount /dev/sdc2
sudo mkfs.ext4 -i 1024 -L rootfs /dev/sdc2
sudo mount /dev/sdc2 /mnt
cd /mnt
sudo tar xvf $1/rootfs.tar
cd $1
sudo umount /dev/sdc2

echo "Installing kernel..."
sudo mount /dev/sdc1 /mnt
#../../../tools/mkimage/mkknlimg $1/zImage $1/zImage.dt
sudo cp $1/zImage /mnt/kernel.img
sudo cp $1/zImage /mnt/kernel7.img
sudo umount /dev/sdc1
