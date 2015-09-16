#!/bin/bash

echo "Installing root fs..."
umount $11
umount $12
sudo mkfs.ext4 -i 1024 -L rootfs $12
sudo mount $12 /mnt
cd /mnt
sudo tar xvf $2/rootfs.tar
cd $2
sudo umount $12

echo "Installing kernel..."
sudo mount $11 /mnt
sudo cp $2/zImage /mnt/kernel.img
sudo cp $2/zImage /mnt/kernel7.img
sudo umount $11
