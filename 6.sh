#!/bin/bash

set -e -o pipefail

echo "Disabling Wayland ..."
sed -i 's/#WaylandEnable/WaylandEnable/' /etc/gdm/custom.conf

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

echo
echo "Installation should be complete."



