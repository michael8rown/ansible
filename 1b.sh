#!/bin/bash

set -e -o pipefail

read -p "What is the root device? " rootdev

read -p "What is the boot device? " bootdev

read -p "What is the swap device? " swapdev

echo "Making the filesystems and activing swap ..."

mkfs.ext4 $rootdev
mount $rootdev /mnt

mkswap $swapdev
swapon $swapdev

mkfs.fat -F 32 $bootdev
mount -o umask=0077 --mkdir $bootdev /mnt/boot

sleep 1

echo "Installing base system ..."
pacstrap -K /mnt linux-lts linux-lts-headers linux-firmware amd-ucode base base-devel reflector git ansible ansible-core openssh nano which sudo bash-completion man-db


echo "Generating fstab ..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Copying install scripts to /mnt ..."
cp * /mnt/.

echo "Entering the chroot environment ..."
arch-chroot /mnt

echo "Base installation is complete. Continue with the next script."

