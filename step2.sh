#!/bin/sh

ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
sed 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "What would you like your new hostname to be?"

read myhostname

echo Setting new host name to $myhostname
echo $myhostname >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $myhostname" >> /etc/hosts

sleep 1

echo "Updating the mirrorlist ..."

reflector -c US --age 48 --sort rate --latest 20 --protocol https --save /etc/pacman.d/mirrorlist
sed 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed 's/#Color/Color/' /etc/pacman.conf

sleep 1

echo "Installing the rest of the system ..."

pacman -Syu --noconfirm accerciser acpi acpi_call-dkms acpid adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts apache arc-gtk-theme arc-icon-theme avahi baobab bluez bluez-utils bridge-utils cheese clamav cups d-spy dconf-editor devhelp dialog dmidecode dnsmasq dosfstools efibootmgr endeavour eog evince evolution ffmpegthumbnailer file-roller firefox firewalld gdm gedit ghex gitg glade gnome-backgrounds gnome-boxes gnome-browser-connector gnome-builder gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-connections gnome-console gnome-contacts gnome-control-center gnome-devel-docs gnome-dictionary gnome-disk-utility gnome-font-viewer gnome-keyring gnome-logs gnome-maps gnome-menus gnome-multi-writer gnome-music gnome-photos gnome-recipes gnome-remote-desktop gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-software gnome-sound-recorder gnome-system-monitor gnome-terminal gnome-text-editor gnome-themes-extra gnome-tour gnome-tweaks gnome-user-docs gnome-user-share gnome-weather gnu-free-fonts gparted grilo-plugins gst-libav gst-plugins-ugly gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb inetutils inter-font iptables-nft libdvdcss lightsoff loupe malcontent mariadb mtools nautilus neofetch network-manager-applet networkmanager nfs-utils noto-fonts noto-fonts-cjk noto-fonts-emoji openbsd-netcat orca pacman-contrib perl-cgi perl-dbd-mysql perl-dbi perl-template-toolkit php php-apache phpmyadmin polari rhythmbox rsync rygel s-nail samba sassc seahorse simple-scan snapshot sshpass sushi sysprof tecla terminus-font tex-gyre-fonts tlp totem tracker3-miners ttf-anonymous-pro ttf-bitstream-vera ttf-cascadia-code ttf-croscore ttf-dejavu ttf-droid ttf-fantasque-sans-mono ttf-fira-code ttf-fira-mono ttf-gentium-plus ttf-hack ttf-ibm-plex ttf-inconsolata ttf-jetbrains-mono ttf-junicode ttf-liberation ttf-linux-libertine ttf-monofur ttf-opensans ttf-roboto virt-manager vlc wireguard-tools wpa_supplicant xdg-desktop-portal-gnome xdg-user-dirs xdg-user-dirs-gtk xdg-utils xorg yay-bin yelp yt-dlp

mkinitcpio -P

sleep 2

echo

echo "Enabling system services ..."
systemctl enable NetworkManager.service
systemctl enable gdm.service
systemctl enable sshd.service
systemctl enable firewalld.service
systemctl enable acpid.service
systemctl enable libvirtd.service
systemctl enable avahi-daemon.service
systemctl set-default graphical.target

echo

sleep 2

echo "Installing systemd boot ..."
bootctl install

sleep 2

echo Adding user michael ...

useradd -mG wheel,libvirt michael

echo "Changing michael's password ..." 

echo michael:password | chpasswd

echo "%wheel ALL=(ALL:ALL) ALL" | (EDITOR="tee -a" visudo)

# echo "michael ALL=(ALL) ALL" >> /etc/sudoers.d/michael
# %wheel ALL=(ALL:ALL) ALL
# echo "$1" | (EDITOR="tee -a" visudo)
#printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

echo
echo "Installation should be complete."
echo "DON'T FORGET TO SET A PASSWORD FOR ROOT AND MICHAEL!!"
echo "and don't forget EDITOR=nano visudo to uncomment the wheel line"


