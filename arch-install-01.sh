#!/bin/bash

echo 'loadkeys'
loadkeys la-latin1

mkfs.fat /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

pacman -Syy
mkdir /mnt/system
mount /dev/nvme0n1p2 /mnt/system
pacstrap /mnt/system base linux-zen linux-zen-headers linux-firmware intel-ucode

genfstab -U /mnt/system >> /mnt/system/etc/fstab
echo '# UUID="xxx" /boot    vfat    rw,discard,relatime,noatime,errors=remount-ro   0 1
' >> /mnt/system/etc/fstab
blkid | grep n1p1 | awk '{print $2}' >> /mnt/system/etc/fstab

cp -R /root/arch-install /mnt/system/root/
arch-chroot /mnt/system
