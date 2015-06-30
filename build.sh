#!/bin/bash

BUILDROOT_CONFIG=${1:-raspi2}

echo "Downloading Buildroot..."
wget http://buildroot.net/downloads/buildroot-2015.05.tar.bz2
tar xjvf buildroot-2015.05.tar.bz2

echo "Configuring..."
cd buildroot-2015.05
make defconfig BR2_DEFCONFIG=../config/buildroot-$BUILDROOT_CONFIG.conf

echo "Starting build, this may take a while..."
make

cd ..
