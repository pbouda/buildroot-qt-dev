# Embedded Qt with Buildroot

This projects provides a Buildroot config and helper scripts to build an
environment for Qt development on embedded systems. The primary target platform
is the Raspberry Pi (A, B(+) and 2).

The following procedure will create a Buildroot environment that allows you to
compile Qt applications for the platforms supported by Buildroot. It will also
create a root filesystem for the target platform that contains a basic embedded
Linux environment and the Qt libraries. If you want to use the root filesystem
you will need a SD card. This repository contains an installation script for
the Raspberry Pi partition layout that will copy the root filesystem to the SD
card. It starts the Buildroot Linux system with an SSH daemon. This setup
allows you to develop Qt applications with the Qt Creator on your host system
and then deploy to the Raspberry. Developing Qt applications for the Raspberry
never was easier!

* Buildroot project: http://buildroot.net/
* Qt project: http://www.qt.io/

As an example project you can check out
[Die Hummbere](http://brummbeere.readthedocs.org/en/latest/), which boots the
Raspberry directly into a Qt ownCould music player. I use to hang out on IRC at
\#buildroot and \#qt if you have any questions or comments.


## License

Buildroot-Qt-Dev source code is distributed under the GNU GENERAL PUBLIC LICENSE
Version 2.

Buildroot-Qt-Dev documentation is Public Domain.


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
and Qt on embedded platform please visit:

http://doc.qt.io/qt-5/embedded-linux.html


## Embedded Linux libraries and applications

The Linux system uses [busybox](http://www.busybox.net/) for most command line
tools and the init system. It is a very basic system that you may adapt to your
needs via the Buildroot configuration system. Besides Qt, the following
libraries and applications are built and installed:

* Several SSL/TLS libaries
* Image format libraries (JPEG, PNG, etc.)
* Some fonts
* GStreamer with ALSA support (for the Qt multimedia module)
* Dropbear SSH (to be able to connect to the device and use Qt Creator later)
* rpi-firmware and rpi-userland (for OpenGL support on the Raspberry)

You can see a full list of the packages that are enabled in the file
`config/buildroot-raspi.conf`.

In addition to Buildroot's default init scripts there a two daemons started:

* An NTP daemon to set the current date/time
* The Dropbear SSH daemon

The script in `scripts/postbuild.sh` is responsible to copy the two init scripts
to the root filesystem after building everything. It is automatically called
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
``buildroot`` folder and load the configuration:

    $ cd buildroot-2015.05
    $ make defconfig BR2_DEFCONFIG=../config/buildroot-raspi2.conf

If you want to build the system for Raspberry A/B(+) then choose the "raspi"
configuration file during this step:

.. code-block:: sh

   $ cd buildroot
   $ make defconfig BR2_DEFCONFIG=../config/buildroot-raspi2.conf


## Install root filesystem on Raspberry


## Compile Qt applications


## Set up Qt Creator