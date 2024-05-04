# Arch Linux Installation and Configuration

This is a collection of BASH and Ansible scripts to automate the installation of Arch Linux, install/enable GNOME extensions, install WhiteSur icons, and set a number of dconf settings the way I like them.

This is my first attempt at reproducing my NixOS experience in Arch. It isn't quite as flawless, but it's very close.

### Before you begin

The Arch iso does not ship with git. Therefore, the first task is to install it with

```
pacman-key --init
sudo pacman -Sy git
```

Once that's complete, clone this repo with

```
git clone https://github.com/michael8rown/ansible.git
```

### Step 1: Pre-installation tasks

`1_pre_install.sh` does some of the usual housekeeping I perform before beginning, such as checking internet connection and running `timedatectl`. (NOTE: Checking internet is actually unncessary; if you don't have an internet connection, you wouldn't be able to install `git` above.)

You are also instructed to format the disk using `cfdisk /dev/disk`, and you are offered a recommended structure. The pattern I always use is

* an EFI boot device at `/dev/vda1`
* a root device at `/dev/vda2`
* and a swap device at `/dev/vda3`

### Step 2: Base Installation

`2_base_install.sh` performs some pre-chroot tasks, such as

* formatting and mounting the devices
* running `pacstrap`
* chrooting into /mnt

### Step 3: Main Installation

Inside the chroot environment, `cd` into the `ansible` directory and run `3_main_install.sh`. This will

* install all the packages I like
* enable all the services I use
* disable Wayland (is Wayland EVER going to figure out how to handle cursors???)
* set the root password
* create a new user
* set that user's password
* add that user to sudo

Once this step is complete, you must reboot.

### Step 4: Post-installation tasks

Once you log in, `cd` into the `ansible` directory and run `4_post_install.sh`, which is an Ansible playbook that configures all the things the way I like them: GNOME extensions, WhiteSur icons, and setting all my desktop preferences.

### Final step

The last step is to reboot again, after which your environment should be set up exactly as defined in the scripts. Enjoy!

### Todo

- [ ] Create a separate file containing a list of all the packages I install in `3_main_install.sh`. That way, I can add/delete packages without needing to touch the actual script.

- [ ] Write some Ansible templates to set up and activate some local services I've written
