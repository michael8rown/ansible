#!/bin/sh

echo "Enabling system services ..."
systemctl enable NetworkManager.service
systemctl enable gdm.service
systemctl enable sshd.service
systemctl enable firewalld.service
systemctl enable acpid.service
systemctl enable libvirtd.service
systemctl enable avahi-daemon.service
systemctl set-default graphical.target

