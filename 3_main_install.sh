#!/bin/bash
set -e -o pipefail

hwclock --systohc
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

read -p "What would you like your new hostname to be?  " myhostname

echo "Setting new host name to ${myhostname}"
echo $myhostname >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 ${myhostname}" >> /etc/hosts

sleep 1

echo "Updating the mirrorlist ..."

reflector -c US --age 48 --sort rate --latest 20 --protocol https --save /etc/pacman.d/mirrorlist
sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf

sleep .5

echo "Installing the rest of the system ..."

apps=`echo $(cat /archinstall/apps.txt)`

pacman -Syu --noconfirm ${apps}

sleep .5

echo "Enabling system services ..."
systemctl enable NetworkManager.service
systemctl enable gdm.service
systemctl enable sshd.service
systemctl enable firewalld.service
systemctl enable acpid.service
systemctl enable libvirtd.service
systemctl enable avahi-daemon.service
systemctl set-default graphical.target

sleep 1

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

sleep .5

echo "Disabling Wayland ..."
sed -i 's/#WaylandEnable/WaylandEnable/' /etc/gdm/custom.conf


echo "Enabling nano syntax highlighting ..."
sed -i 's/^# include \"\/usr\/share\/nano\/\*\.nanorc\"/include "\/usr\/share\/nano\/\*\.nanorc"/' /etc/nanorc

echo
echo "Changing root's password ..."

passwd

echo
echo "Creating a new regular user ..."
read -p "Enter username:  " username

echo
echo "Adding user ${username} ..."

useradd -mG wheel,libvirt $username

echo "Changing ${username}'s password ..."

passwd $username

echo
echo "Adding ${username} to sudoers ..."

echo "%wheel ALL=(ALL:ALL) ALL" | (EDITOR="tee -a" visudo)

echo "Moving archinstall files to ${username}'s home directory ..."
cp -r archinstall /home/${username}/.

echo "Updating permissions on archinstall folder ..."
chown -R ${username}:${username} /home/${username}/archinstall

echo
echo "Success!!"
echo "Installation should be complete."
echo "You should now exit the chroot environment, unmount devices, and reboot."
echo "Once rebooted, run the script called"
echo "  >>  /home/${username}/archinstall/4_after_reboot.sh"


