#!/bin/sh

echo "Installing systemd boot ..."
bootctl install

echo "default arch-lts.conf" >> /boot/loader/loader.conf
echo "timeout 5" >> /boot/loader/loader.conf
echo "console-mode keep" >> /boot/loader/loader.conf
echo "editor no" >> /boot/loader/loader.conf

getroot=`df -h | grep -E '.+/$'`
rootdev=`echo $getroot | sed -E 's/^([^ ]+) .*$/\1/g'`
f=`blkid | grep $rootdev | sed -E 's/^.+ UUID="([^"]+)".+$/\1/g'`

echo "title   Arch Linux LTS" >> /boot/loader/entries/arch-lts.conf
echo "linux   /vmlinuz-linux-lts" >> /boot/loader/entries/arch-lts.conf
echo "initrd  /initramfs-linux-lts.img" >> /boot/loader/entries/arch-lts.conf
echo "options root=UUID=${f} rw" >> /boot/loader/entries/arch-lts.conf

echo "title   Arch Linux LTS (fallback)" >> /boot/loader/entries/arch-lts-fallback.conf
echo "linux   /vmlinuz-linux-lts" >> /boot/loader/entries/arch-lts-fallback.conf
echo "initrd  /initramfs-linux-lts-fallback.img" >> /boot/loader/entries/arch-lts-fallback.conf
echo "options root=UUID=${f} rw" >> /boot/loader/entries/arch-lts-fallback.conf
