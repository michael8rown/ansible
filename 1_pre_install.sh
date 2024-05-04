#!/bin/bash
set -e -o pipefail

setfont ter-132b

echo "Checking efi ..."
cat /sys/firmware/efi/fw_platform_size

# If the command returns 64, then system is booted in UEFI mode and has a 64-bit x64 UEFI. If the command returns 32, then system is booted in UEFI mode and has a 32-bit IA32 UEFI; while this is supported, it will limit the boot loader choice to systemd-boot and GRUB. If the file does not exist, the system may be booted in BIOS (or CSM) mode. If the system did not boot in the mode you desired (UEFI vs BIOS), refer to your motherboard's manual. 

echo "Checking internet connection ..."
ping -c 3 archlinux.org

timedatectl

echo "Now you must partition the drive. Once that's complete, run /ansible/2_install.sh"

echo "Example partition setup:

cfdisk /dev/the_disk_to_be_partitioned

Mount point on the installed system 	Partition 	Partition type 	Suggested size
/boot1 	/dev/efi_system_partition 	EFI system partition 	1 GiB
[SWAP] 	/dev/swap_partition 	Linux swap 	At least 4 GiB
/ 	/dev/root_partition 	Linux x86-64 root (/) 	Remainder of the device. At least 23–32 GiB.
"

