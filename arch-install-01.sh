#!/bin/bash

echo 'loadkeys'
loadkeys la-latin1

mkfs.fat /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

pacman -Syy
pacman -S git
git clone https://github.com/alvaro-araya/arch-install.git
cd arch-install; git checkout gnome-install; cd ..

mkdir /mnt/system
mount /dev/nvme0n1p2 /mnt/system
pacstrap /mnt/system linux-zen linux-zen-headers linux-firmware intel-ucode arch-install-scripts

cp -R /root/arch-install /mnt/system/root/
arch-chroot /mnt/system