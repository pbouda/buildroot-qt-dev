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


## Embedded Linux enviroment and apps

The Linux system uses busybox for most command line tools and the init system.
It is a very basic system that you may adapt to your needs via the Buildroot
configuration system. Besides Qt, the following applications are installed:

* Several SSL/TLS libaries
* Image format libraries (JPEG, PNG, etc.)
* Some fonts
* GStreamer (for the Qt multimedia module)
* Dropbear SSH (to be able to connect to the device and use Qt Creator later)
* rpi-firmware and rpi-userland (for OpenGL support)

You can see a full list of the packages that are enabled in the file
`config/buildroot-raspi.conf`.

In addition to Buildroot's default init scripts there a two daemons started:

* An NTP daemon to set the current date/time
* The Dropbear SSH daemon

The script in `scripts/postbuild.sh` is responsible to copy the two init scripts
to the root filesystem after building everything. It is automatically called
by Buildroot.


## Build everything


## Install root filesystem on Raspberry


## Compile Qt applications


## Set up Qt Creator