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

sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf

echo "Installing base system ..."
pacstrap -K /mnt linux-lts linux-lts-headers linux-firmware amd-ucode base base-devel reflector git ansible ansible-core openssh nano which sudo bash-completion man-db

echo "Generating fstab ..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Copying install scripts to /mnt ..."
cp -r ../ansible /mnt/.

echo "Base installation is complete."
echo "Continue installation with /ansible/3_install.sh."

secs=$((10))
while [ $secs -gt 0 ]; do
   echo -ne "  Entering chroot environment in > $secs\033[0K\r"
   sleep 1
   : $((secs--))
done

arch-chroot /mnt
