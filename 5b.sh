#!/bin/bash

set -e -o pipefail

echo "Installing systemd boot ..."
bootctl install

sleep 1

echo "default arch-lts.conf
timeout 5
console-mode keep
editor no" >> /boot/loader/loader.conf

getroot=`df -h | grep -E '.+/$'`
rootdev=`echo $getroot | sed -E 's/^([^ ]+) .*$/\1/g'`
f=`blkid | grep $rootdev | sed -E 's/^.+ UUID="([^"]+)".+$/\1/g'`

echo "title   Arch Linux LTS
linux   /vmlinuz-linux-lts
initrd  /initramfs-linux-lts.img
options root=UUID=${f} rw" > /boot/loader/entries/arch-lts.conf

echo "title   Arch Linux LTS (fallback)
linux   /vmlinuz-linux-lts
initrd  /initramfs-linux-lts-fallback.img
options root=UUID=${f} rw" > /boot/loader/entries/arch-lts-fallback.conf
