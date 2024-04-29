#!/bin/bash

set -e -o pipefail

hwclock --systohc
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

