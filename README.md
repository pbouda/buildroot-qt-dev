# Embedded Qt with Buildroot

This projects provides a Buildroot config and helper scripts to build an
environment for Qt development on embedded systems. The primary target platform
is the Raspberry Pi (A, B(+) and 2).

The following procedure will create a Buildroot environment that allows you to
compile Qt applications for the platforms supported by Buildroot. It will also
create a root filesystem for the target platform that contains a basic embedded
Linux environment and the Qt libraries. If you want to use the root file system
you will need a SD card. This repository contains an installation script for
the Raspberry Pi partition layout that will copy the root file system to the SD
card. It starts the Buildroot Linux system with an SSH daemon. This setup
allows you to develop Qt applications with the Qt Creator on your host system
and then deploy to the Raspberry. Developing Qt applications for the Raspberry
has never been easier!

* Buildroot project: http://buildroot.net/
* Qt project: http://www.qt.io/

As an example project you can check out
[Die Brummbere](http://brummbeere.readthedocs.org/en/latest/), which boots the
Raspberry directly into a Qt ownCould music player.


## License

Buildroot-Qt-Dev source code is distributed under the GNU GENERAL PUBLIC LICENSE
Version 3.

## Qickstart

The repository contains a shell script that will execute all the steps that I
describe below. To build the Buildroot environment in one step just type:

    $ ./build.sh

This will build everything for the Raspberry 2. You can pass a parameter `raspi`
to the script to build for Raspberry A/B(+):

    $ ./build.sh raspi

There are two experimental configurations that use systemd instead of busybox
as init system. Those are called `raspi2-systemd` and `raspi-systemd`. The
simpler and default busybox init system should work fine for most use cases.

After the build is done you can directly jump to the [section to install the
root filesystem on your SD
card](#install-root-filesystem-on-sd-card-for-raspberry).

## Qt features and modules

After building, the Buildroot environment will provide the following Qt modules:

* GUI with Widgets and OpenGL
* Declarative with Qt Quick
* Qt Quick Controls
* DBus
* Multimedia (with GStreamer backend)
* Image Formats
* Connectivity
* Graphical Effects

Network connections via SSL/TLS are supported.

For graphical output the system supports LinuxFB and EGLFS. The latter is the
default. For more information about the configuration of the platform plugins
and Qt on embedded platforms please visit:

http://doc.qt.io/qt-5/embedded-linux.html


## Embedded Linux libraries and applications

The Linux system uses [busybox](http://www.busybox.net/) for most command line
tools and the init system. It is a very basic system that you may adapt to your
needs via the Buildroot configuration system. Besides Qt, the following
libraries and applications are built and installed:

* SSL/TLS libaries
* Image format libraries (JPEG, PNG, etc.)
* Some fonts
* GStreamer with ALSA support (for the Qt multimedia module)
* OpenSSH (to be able to connect to the device and use Qt Creator later)
* NTP client (to synchronize time, as the Raspberry does not have a real-time
    clock)
* rpi-firmware and rpi-userland (for OpenGL support on the Raspberry)

You can see a full list of the packages that are enabled in the file
`config/buildroot-raspi.conf`.

In addition to Buildroot's default init scripts the scripts of this repository
install and start two daemons:

* An NTP daemon to set the current date/time
* The Dropbear SSH daemon

The script in `scripts/postbuild.sh` is responsible to copy the two init scripts
to the root file system after building everything. It is automatically called
by Buildroot. The two init scripts are in `userland/target`.


## Build everything

In this step we will build a complete Linux system including the kernel and the
Qt libraries.


### Buildroot configuration

First you need to download this repository and Buildroot. We will use the
the current release `2015-05` of Buildroot, which is the first release that
supports the Raspberry 2. Just download and unpack Buildroot into your clone of
`buildroot-qt-dev`:

    $ git clone https://github.com/pbouda/buildroot-qt-dev.git
    $ cd buildroot-qt-dev
    $ wget http://buildroot.net/downloads/buildroot-2015.05.tar.bz2
    $ tar xjvf buildroot-2015.05.tar.bz2


In the next step we configure buildroot for the Raspberry Pi 2 and a complete
Qt framework with dependencies like GStreamer. The folder `config` contains a
Buildroot configuration file to set all options that we need. Enter the
`buildroot-2015.05` folder and load the configuration:

    $ cd buildroot-2015.05
    $ make defconfig BR2_DEFCONFIG=../config/buildroot-raspi2.conf

If you want to build the system for Raspberry A/B(+) then choose the "-raspi"
configuration file during this step:

    $ cd buildroot-2015.05
    $ make defconfig BR2_DEFCONFIG=../config/buildroot-raspi.conf


### Start the build process

You can now start the build process. This will download and build the toolchain,
Linux and all libraries and applications. The whole procedure might take a
while, up to a few hours. Just run:

    $ make

Buildroot will put all results of the build process in the folder `output`.


## Install root filesystem on SD card for Raspberry

In this step we will install the root file system on a SD card that will boot
the Raspberry. Buildroot put the file system into a folder `output/images`. We
will extract the image from there. But first, we have to prepare the SD card
with a specific partition layout for the Raspberry.


### Prepare SD card

The SD card has to co be prepared with a certain partition layout in order to
be bootable on the Raspberry. The standard layout is a small FAT partition and
a larger ext4 partition in this order. The easiest way to prepare the card is
to install a standard Raspbian on the card. This will also install the
mandatory binary firmware and license to boot the Raspberry. You can find
information about the process on the Raspberry download page:

https://www.raspberrypi.org/downloads/

Just follow the instructions given on the page under the `Raspbian` heading.


### Modify and run installation script

To install the root file system we will now format the second partition on the
SD card with an ext4 file system, extract the file system that Buildroot created
and copy the Buildroot kernel onto the first FAT partition. The repository
contains the file `script/installrootfs.sh` that executes all commands. The
script needs to know the device of your SD card. Please check carefully which
device your SD card uses and adapt the script. Currently the device for the SD
card is `/dev/sdX`. Change those device names to your setup *in all locations*.

If your SD card is still mounted from the previous step you might just call
`mount` to see a list of all file systems. Find your SD card in this list and
use the device names that are listed (like `/dev/sdc1` and `/dev/sdc2`).

*Careful: Your SD card has to prepared with the two Raspberry partitions. If
you do not edit the script `installrootfs.sh` with the correct device names
your hard disk might get formatted!*

You can now run the script. The script expects the path to the root file system
image and the kernel as the first argument. Buildroot puts those in the folder
`output/images`. So change directory into `scripts` and run `installrootfs.sh`
with the absolute path to your `buildroot-2015.05/output/images` folder:

    $ cd ../scripts/
    $ ./installrootfs.sh /path/to/buildroot-qt-dev/buildroot-2015.05/output/images

This will format, extract and copy. After the script finishes it is safe to
remove the SD card from your computer and insert it into your Raspberry. Power
on the Raspberry and see the system boot. If you attached a network cable
you should be able open a shell via SSH. The username is `root` with password
`raspi`. Here is a nice one liner to find your Raspberry on the network (needs
`nmap` installed):

    $ sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'

[via [pierre-o's Known](https://microblog.pierre-o.fr/2015/one-liner-to-find-raspberrypi-on-your-local-network)]


## Compile Qt applications

You can now use the Buildroot `qmake` executable to generate your Qt project.
The command is available in Buildroot's `output/host/usr/bin` directory.

As an example, we will compile the project Die Brummbeere. Just check out the
code, run `qmake` followed by `make`:

    $ cd ..
    $ git clone https://github.com/pbouda/brummbeere.git
    $ cd brummbeere/src/
    $ ../../buildroot-2015.05/output/host/usr/bin/qmake Brummbeere.pro
    $ make

This will build the executable `brummbeere` in the `mainapp` directory. You can
now copy the executable to the Raspbery and run Die Brummbeere.


## Set up Qt Creator

See [doc/qtcreator.md](https://github.com/pbouda/buildroot-qt-dev/blob/master/doc/qtcreator.md).


## Need help?

Contact me here: http://www.peterbouda.eu/#contact

I am available to hire, contact me if you need a programmer for your Embedded
Qt project!