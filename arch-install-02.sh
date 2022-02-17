#!/bin/bash
loadkeys la-latin1

echo "Date and Time"
timedatectl set-ntp true
timedatectl set-timezone America/Costa_Rica

echo "Pacman Update"
pacman -Syy

echo "Terminal Font and Layout"
pacman -S nano terminus-font
cat << 'EOF' > /etc/vconsole.conf
KEYMAP=la-latin1
FONT=ter-112n
EOF

echo "locale-gen"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

echo "locale.conf"
echo "LANG=en_US.UTF-8\nLC_CTYPE=en_US.UTF-8\n">> /etc/locale.conf

echo "/etc/hosts"
echo "127.0.0.1 localhost\n::1 localhost\n127.0.0.1 xyz-arch-pc.localhost xyz-arch-pc\n" >> /etc/hosts

echo "/etc/hostname"
echo "xyz-arch-pc" > /etc/hostname

echo "Network Manager"
pacman -S networkmanager
systemctl enable NetworkManager.service
systemctl disable NetworkManager-wait-online.service

echo "Boot Install"
mv /boot /boot-install
mkdir /boot
mount /dev/nvme0n1p1 /boot
cp -R /boot-install/* /boot
bootctl install

echo "Bootctl loader.conf"
cat << 'EOF' > /boot/loader/loader.conf
default entries/arch.conf
console-mode max
editor yes
timeout 0
EOF

echo "Bootctl arch.conf"
cat << 'EOF' > /boot/loader/entries/arch.conf
title Arch Linux Zen - xyz-arch-pc
linux /vmlinuz-linux-zen
initrd /intel-ucode.img
initrd /initramfs-linux-zen.img
options root=PARTUUID="" rootfstype="ext4" rw add_efi_memmap loglevel=3 i8042.nomux=1 i8042.reset
EOF
sed -i "s/PARTUUID=\"\"/$(blkid | grep n1p2 | awk '{print $5}')/g" /boot/loader/entries/arch.conf

echo "Bootctl arch-fallback.conf"
cat << 'EOF' > /boot/loader/entries/arch-fallback.conf
title Arch Linux Zen Fallback - xyz-arch-pc
linux /vmlinuz-linux-zen
initrd /intel-ucode.img
initrd /initramfs-linux-zen-fallback.img
options root=PARTUUID="" rootfstype="ext4" rw add_efi_memmap loglevel=3 i8042.nomux=1 i8042.reset vt.color=0x02
EOF
sed -i "s/PARTUUID=\"\"/$(blkid | grep n1p2 | awk '{print $5}')/g" /boot/loader/entries/arch-fallback.conf

echo 'Pacman Hooks'
mkdir /etc/pacman.d/hooks
cat << 'EOF' > /etc/pacman.d/hooks/100-systemd-boot-update.hook
[Trigger]
Type=Package
Operation=Upgrade
Target=systemd
[Action]
Description=Updating systemd-boot
When=PostTransaction
Exec=/usr/bin/bootctl update
EOF

cat << 'EOF' > /etc/pacman.d/hooks/100-nvidia.hook
[Trigger]
Type=Package
Operation=Install
Operation=Upgrade
Operation=Remove
Target=nvidia
Target=linux

[Action]
Description=Updating nvidia-module
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF

cat << 'EOF' > /etc/pacman.d/hooks/90-mirrorlist-update.hook
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c 'systemctl start reflector.service; [ -f /etc/pacman.d/mirrorlist.pacnew ] && rm /etc/pacman.d/mirrorlist.pacnew'
EOF

echo 'NVIDIA install'
pacman -S nvidia nvidia-utils nvidia-settings nvidia-prime nvidia-dkms

echo 'NVIDIA env'
cat << 'EOF' >> /etc/environment
CLUTTER_DEFAULT_FPS=144
__GL_SYNC_DISPLAY_DEVICE=eDP-1-1
VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=eDP-1-1
__GL_SYNC_TO_VBLANK=0
EOF

echo 'sudo'
pacman -S sudo
echo 'xyz ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/xyz
useradd -m xyz
echo 'xyz password:'
passwd xyz
echo 'root password:'
passwd

echo 'Prepara arch-install-03 en el user'
cat << 'EOF' >> /home/xyz/arch-install-03.sh
#!/bin/bash
echo 'Paquetes básicos'
sudo pacman -S base-devel most rsync p7zip zsh git

echo 'PARU'
cd /home/xyz
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
rm -fR paru

paru ite8291r3-ctl
paru google-chrome
EOF
chmod 755 /home/xyz/xyz-install-03.sh

echo 'sudo'
pacman -S sudo
echo 'xyz ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/xyz
useradd -m xyz
echo 'xyz password:'
passwd xyz
echo 'root password:'
passwd

echo '-------------------------------------------------------'
echo 'Ajustes Finales'
echo '-------------------------------------------------------'
echo 'Ajustar el /etc/fstab'
echo 'Ajustar los archivos conf en /boot/loader/...'
echo 'editar /etc/vconsole.conf agregar en hooks: consolefont'
echo 'Ejecutar mkinitcpio -P'
echo 'Ejecutar bootctl update'
echo '-------------------------------------------------------'
