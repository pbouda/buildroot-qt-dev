#!/bin/bash

echo "Start DHCP..."
install -m 755 ../userland/target/S41udhcpc $1/etc/init.d/


