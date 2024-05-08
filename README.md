# Arch Linux Installation and Configuration

This is a collection of BASH and Ansible scripts to automate the installation of [Arch Linux](https://archlinux.org/) in UEFI mode, install/enable GNOME extensions, install WhiteSur icons, and set a number of dconf settings the way I like them.

This is my first attempt at reproducing my NixOS experience in Arch. It isn't quite as flawless, but it's very close.

### Prerequisites

This project assumes that you have already downloaded Arch and have it ready to go on a thumb drive or some other medium from which you can install it.

It also assumes that you have a better-than-beginner understanding of disk partitioning (I prefer `cfdisk`), especially if you are planning to use the project to install Arch alongside another distribution. **I take no responsibility for loss of data.** I have not tested this project in a dual-boot situation so I cannot vouch for its reliability in that regard.

### Step 1: Pre-installation tasks

The first step is to boot the installation iso. Once booted, you will need to install `git` because the iso does not ship with it.

```
pacman-key --init
pacman -Sy git
```

Once installed, clone this repo with

```
git clone https://github.com/michael8rown/archinstall.git
```

`1_pre_install.sh` does some of the usual housekeeping I perform before beginning, such as checking internet connection and running `timedatectl`.

You are also instructed to format the disk using (for example) `cfdisk /dev/vda`, and you are offered a recommended structure. The pattern used in this example is:

* select `gpt` as the label
* create a 1GB EFI `boot` partition (e.g.,` /dev/vda1`)
* create a 17GB `root` partition (`/dev/vda2`)
* and create a 2GB `swap` partition (`/dev/vda3`)

### Step 2: Installation

`2_base_install.sh` expects you to provide certain information:

* the partition names created at the end of **Step 1** above (e.g. `/dev/vda1`, etc.)
* a hostname (e.g. `archtest`)
* a root password
* a new user name
* and a password for that user

Once you are prepared to provide this information, run `2_base_install.sh` which will automatically perform the following tasks:

* format and mount the devices
* run `pacstrap`
* `arch-chroot` into `/mnt` to run `/archinstall/3_main_install.sh`, which will
* install all the packages I like (you can edit `apps.txt` to add/delete packages of your choice. **NOTE:** some of the tasks/services in these scripts depend on certain packages. For example, this script enables NetworkManager. If you choose not to install NetworkManager, the script will fail.)
* enable all the services I use
* disable Wayland (is Wayland ***ever*** going to figure out how to handle cursors?)
* enable syntax highlighting in `nano`
* set the root password
* create a new user
* set that user's password
* add that user to sudo
* run `/archinstall/4_post_install_sh`, an Ansible playbook that will
* download, install, and enable the GNOME extensions listed in `ext.yml` (edit this as you please, but note that one Ansible task expects Blur My Shell to be installed. If you don't wish to install that extension, be sure to remove that task from the playbook)
* download and install [vinceliuice's amazing WhiteSur icons](https://github.com/vinceliuice/WhiteSur-icon-theme)
* copy and set the wallpaper from this repo
* and set a long list of dconf settings the way I like them (these are contained in `dconf.yml`; feel free to add/remove settings as you see fit)

### Step 3: Reboot

Provided there were no errors along the way, the last step is to `umount -a && reboot`, after which your environment should be set up exactly as defined in the scripts. Enjoy!

### TODO

- [x] Create a separate file containing a list of all the packages I install in `3_main_install.sh`. That way, I can add/delete packages without needing to touch the actual script.

- [ ] Write some Ansible templates to set up and activate some local services I've written

- [ ] Automate disk partitioning **NOTE** a test version of this task (`disk.sh`) is included here but it is not complete and should be used with great caution. It is extremely destructive. **USE AT YOUR OWN RISK!!**

