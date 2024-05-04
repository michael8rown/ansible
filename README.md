# Ansible for Arch

This is a collection of BASH and Ansible scripts to automate the installation of Arch Linux, install/enable GNOME extensions, install WhiteSur icons, and set a number of dconf settings the way I like them.

This is my first attempt at reproducing my NixOS experience in Arch. It isn't quite as flawless, but it's very close.

## Before you begin

The Arch iso does not ship with git. Therefore, the first task is to install it with

```sudo pacman -Sy git```

Once that's complete, clone this repo with

```git clone https://www.github.com/michael8rown/ansible```

and then proceed with step 1, `1_pre_install.sh`.

## Step 1: Pre-installation tasks

`1_pre_install.sh` does some of the usual housekeeping I perform before beginning, such as checking internet connection and running `timedatectl`. Checking internet is actually unncessary because, if you didn't have an internet connection, you would not have been able to install `git` above.

You are also instructed to format the disk using `cfdisk /dev/disk`. You'll need to create an EFI boot device, a root device, and a swap device.

## Step 2: Base Installation

`2_install.sh` does all the pre-chroot tasks, such as formatting the devices, running `pacstrap`, and then finally chrooting.

## Step 3: Main Installation

Inside the chroot environment, run `3_install.sh`. This will install all the packages I like, it will enable all the services I use, it will set the root password, it will create a new user and set that user's password, and then it will add that user to sudo.

Once this step is complete, you must reboot.

## Step 4: Post-installation tasks

`4_post_install.sh` is an Ansible playbook that configures all the things the way I like them: GNOME extensions, WhiteSur icons, and setting all my desktop preferences.

Once this script is complete, you must reboot again. 

## Final step

When you reboot, your environment should be set up exactly as defined in the scripts.

Enjoy :-)
