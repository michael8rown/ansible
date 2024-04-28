#!/bin/sh

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
sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf

