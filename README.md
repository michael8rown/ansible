# Ansible for Arch

This is a collection of BASH and Ansible scripts to automate the installation of Arch Linux, install/enable GNOME extensions, install WhiteSur icons, and set a number of dconf settings the way I like them.

This is my first attempt at reproducing my NixOS experience in Arch. It isn't quite as flawless, but it's very close.

### Before you begin

The Arch iso does not ship with git. Therefore, the first task is to install it with

```
sudo pacman -Sy git
```

Once that's complete, clone this repo with

```
git clone https://www.github.com/michael8rown/ansible
```

### Step 1: Pre-installation tasks

`1_pre_install.sh` does some of the usual housekeeping I perform before beginning, such as checking internet connection and running `timedatectl`. Checking internet is actually unncessary because, if you didn't have an internet connection, you would not have been able to install `git` above.

You are also instructed to format the disk using `cfdisk /dev/disk`, and you are given a recommended sturcture. The pattern I always use is

* an EFI boot device at `/dev/vda1`
* a root device at `/dev/vda2`
* and a swap device `/dev/vda3`

### Step 2: Base Installation

`2_install.sh` performs some pre-chroot tasks, such as

* formatting and mounting the devices
* running `pacstrap`
* chrooting into /mnt

### Step 3: Main Installation

Inside the chroot environment, run `3_install.sh`. This will

* install all the packages I like
* enable all the services I use
* set the root password
* create a new user
* set that user's password
* add that user to sudo

Once this step is complete, you must reboot.

### Step 4: Post-installation tasks

`4_after_reboot.sh` is an Ansible playbook that configures all the things the way I like them: GNOME extensions, WhiteSur icons, and setting all my desktop preferences.

### Final step

The last step is to reboot again, after which your environment should be set up exactly as defined in the scripts.

Enjoy :-)

### Todo

- [ ] Create a separate file containing a list of all the packages I install in `3_install.sh`. That way, I can add/delete packages without needing to touch the actual script.

- [ ] Write some Ansible templates to set up and activate some local services I've written
