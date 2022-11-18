#!/bin/bash

echo 'loadkeys'
loadkeys la-latin1

mkfs.fat /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

pacman -Syy
mkdir /mnt/system
mount /dev/nvme0n1p2 /mnt/system
mkdir /mnt/system/boot 
mount /dev/nvme0n1p1 /mnt/system/boot

pacstrap /mnt/system base linux-zen linux-zen-headers linux-firmware intel-ucode nano

genfstab -U /mnt/system >> /mnt/system/etc/fstab

echo '# rw,discard,relatime,noatime,errors=remount-ro   0 1' >> /mnt/system/etc/fstab

cp -R /mnt/sd/arch-install /mnt/system/root/
arch-chroot /mnt/system
