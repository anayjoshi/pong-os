# PongOS

**PongOs** is a toy project which was inspired from [MikeOS](http://mikeos.berlios.de). **PongOS** grew out of my fascination of making a standalone application (the Pong Game) which would not need the support of any operating system. 

## Installation

To Download the source

```
git clone http://github.com/anayjoshi/pong-os
cd pong-os
```

To emulate PongOS without risking a pendrive, you need to install **qemu**. To emulate PongOS using qemu, run the following 

```
$ sudo make emulate
```
To actually burn PongOS on a pendrive, you would need to execute a command which looks approximately like this: 

```
$ make PongOS.flp
$ dd if=PongOS.flp of=/dev/sdb
```

The value of `of` depends on the device filename of your pendrive. Note that to build PongOS.flp, [nasm](http://www.nasm.us/) and [mkdosfs](http://en.wikipedia.org/wiki/Mkdosfs) are required to be installed on your laptop.

## Rules

The player plays against the computer. Note that the computer is always able to hit back the ball. The player wins if s/he is able to hit the ball 5 times. Else, the computer wins. The score is displayed in the center of the screen.

## Useful Links for toy OS development


- [MikeOS](http://mikeos.berlios.de"): The inspiration behind PongOS
- [Qemu](http://wiki.quemy.org/Main_Page): A very dependable emulation tool
- [OS-Dev](http://wiki.osdev.org/‎): Excellent repository to get started with OS development

## Snapshot

![Pong Working](/docs/img/pong-working.png?raw=true "Pong Working")

