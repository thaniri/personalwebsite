---
date: 2019-12-01T00:00:00+00:00
title: Rename A Volume Group On Ubuntu 16.04
description: When using LVM, the vgrename command can rename a volume group. But there are more steps required in order to get the OS to use the new volume group correctly.
tags:
  - linux
  - sysadmin
weight: -210
---

1. `sudo vgrename <oldName> <newName>`
2. `sudo vgchange -ay`
3. Modify files that contain references to logical volumes from the old volume group:
  * /etc/fstab
  * /boot/grub/grub.cfg
  * /etc/initramfs-tools/conf.d/resume
4. `sudo update-initramfs -u -k all`
5. `sudo shutdown -r now`

