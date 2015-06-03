#!/bin/bash

echo "Start network..."
install -m 755 ../userland/target/S41udhcpc $1/etc/init.d/
install -m 755 ../userland/target/S52ntp $1/etc/init.d/


