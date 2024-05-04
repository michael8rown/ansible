# Arch Linux Installation and Configuration

This is a collection of BASH and Ansible scripts to automate the installation of Arch Linux in UEFI mode, install/enable GNOME extensions, install WhiteSur icons, and set a number of dconf settings the way I like them.

This is my first attempt at reproducing my NixOS experience in Arch. It isn't quite as flawless, but it's very close.

### Step 1: Pre-installation tasks

The Arch iso does not ship with `git`. Therefore, the first task is to install it with

```
pacman-key --init
sudo pacman -Sy git
```

Once that's complete, clone this repo with

```
git clone https://github.com/michael8rown/archinstall.git
```

`1_pre_install.sh` does some of the usual housekeeping I perform before beginning, such as checking internet connection and running `timedatectl`. (NOTE: Checking internet is actually unncessary; if you don't have an internet connection, you wouldn't be able to install `git` above.)

You are also instructed to format the disk using (for example) `cfdisk /dev/vda`, and you are offered a recommended structure. The pattern I always use is:

* select `gpt` as the format
* create an EFI boot device at `/dev/vda1`
* create a root device at `/dev/vda2`
* and create a swap device at `/dev/vda3`

### Step 2: Base Installation

Before continuing, run `lsblk` and note the names of the partitions you created at the end of **Step 1**. The output will look something like this:

```
example
```

Make note of device names you've assigned becuase you will be asked for those details when you run `2_base_install.sh`. Using the example above, 

* `/dev/vda1` is the `boot` parition
* `/dev/vda2` is the `root` parition
* `/dev/vda3` is the `swap` parition

Once you've collected this information, run `2_base_install.sh` to perform some pre-chroot tasks, such as

* formatting and mounting the devices
* running `pacstrap`
* chrooting into /mnt

### Step 3: Main Installation

Inside the chroot environment, `cd` into the `archinstall` directory and run `3_main_install.sh`. This will

* install all the packages I like
* enable all the services I use
* disable Wayland (is Wayland ***ever*** going to figure out how to handle cursors?)
* enable syntax highlighting in `nano`
* set the root password
* create a new user
* set that user's password
* add that user to sudo

Once this step is complete, you must reboot.

### Step 4: Post-installation tasks

Once you log in, `cd` into the `archinstall` directory and run `4_post_install.sh`, which is an Ansible playbook that configures all the things the way I like them: GNOME extensions, WhiteSur icons, and setting all my desktop preferences.

### Step 5: Reboot

The last step is to reboot again, after which your environment should be set up exactly as defined in the scripts. Enjoy!

### Todo

- [x] Create a separate file containing a list of all the packages I install in `3_main_install.sh`. That way, I can add/delete packages without needing to touch the actual script.

- [ ] Write some Ansible templates to set up and activate some local services I've written
