#!/bin/bash
loadkeys la-latin1

echo "Date and Time"
timedatectl set-ntp true
timedatectl set-timezone America/Costa_Rica

echo "Pacman Update"
pacman -Syy

echo "Terminal Font and Layout"
pacman -S nano terminus-font archlinux-keyring
cat << 'EOF' > /etc/vconsole.conf
KEYMAP=la-latin1
FONT=ter-124n
EOF

echo "Locale"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

localectl set-locale en_US.UTF-8

echo "Hosts"
echo "127.0.0.1 aao-xpg.localhost aao-xpg" >> /etc/hosts

hostnamectl set-hostname aao-xpg

echo "Network Manager"
pacman -S networkmanager
systemctl enable NetworkManager.service

echo "Boot Install"
mv /boot /boot-install
mkdir /boot
mount /dev/nvme0n1p1 /boot
cp -R /boot-install/* /boot
rm -fR /boot-install
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
title Arch Linux Zen - aao-xpg
linux /vmlinuz-linux-zen
initrd /intel-ucode.img
initrd /initramfs-linux-zen.img
options root=PARTUUID="xxx" rootfstype="ext4" rw add_efi_memmap loglevel=3 i8042.nomux=1 i8042.reset quiet drm.edid_firmware=edid/edid.bin nvidia-drm.modeset=1
EOF
blkid | grep n1p2 | awk '{print $5}' >> /boot/loader/entries/arch.conf

echo "Bootctl arch.conf"
cat << 'EOF' > /boot/loader/entries/arch-fallback.conf
title Arch Linux Zen Fallback - aao-xpg
linux /vmlinuz-linux-zen
initrd /intel-ucode.img
initrd /initramfs-linux-zen-fallback.img
options root=PARTUUID="xxx" rootfstype="ext4" rw add_efi_memmap loglevel=3 i8042.nomux=1 i8042.reset vt.color=0x02
EOF
blkid | grep n1p2 | awk '{print $5}' >> /boot/loader/entries/arch-fallback.conf

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

cat << 'EOF' > /etc/pacman.d/hooks/nvidia.hook
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

echo 'Package Install -------------------------------------------'
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && pacman-key --add sublimehq-pub.gpg && pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | tee -a /etc/pacman.conf

pacman -Syu nvidia-dkms nvidia-utils nvidia-settings nvidia-prime base-devel most rsync p7zip zsh git sudo \
xorg xorg-server xorg-xinit glxinfo cinnamon cinnamon-screensaver nemo nemo-fileroller nemo-preview \
kitty gnome-keyring seahorse archlinux-wallpaper pipewire pipewire-{alsa,jack,pulse} easyeffects piper \
openvpn networkmanager-l2tp networkmanager-openvpn iperf net-tools nmap dnsutils openfortivpn \
ghostwriter wget htop lsd pwgen fuse bat ncdu grc libreoffice-fresh hunspell hunspell-es_cr \
remmina archlinux-keyring docker docker-compose mtr remmina freerdp ipcalc neofetch xclip sublime-text sublime-merg

echo 'NVIDIA env'
cat << 'EOF' >> /etc/environment
CLUTTER_DEFAULT_FPS=165
__GL_SYNC_DISPLAY_DEVICE=eDP-1-1
__GL_SYNC_TO_VBLANK=0
EOF

echo 'sudo'
echo 'aao ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/aao
useradd -m aao
echo 'aao password:'
passwd aao
echo 'root password:'
passwd

echo 'Prepara arch-install-03 en el user'
cat << 'EOF' >> /home/aao/arch-install-03.sh
#!/bin/bash
echo 'PARU'
cd /home/aao
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
rm -fR paru

# paru ite8291r3-ctl
paru google-chrome
EOF
chmod 777 /home/aao/arch-install-03.sh

echo '------------------------------------------------------------'
echo 'Ajustes Finales'
echo '------------------------------------------------------------'
echo 'Ajustar el /etc/fstab'
echo 'Ajustar los archivos conf en /boot/loader/...'
echo 'editar /etc/mkinitcpio.conf agregar en hooks: sd-consolefont'
echo 
echo 'Ejecutar mkinitcpio -P'
echo 'Ejecutar bootctl update'
echo '------------------------------------------------------------'
read -p "Iniciará la edición de los archivos"
nano /etc/fstab
nano /boot/loader/entries/arch.conf
nano /boot/loader/entries/arch-fallback.conf
echo '# MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)' >> /etc/mkinitcpio.conf
echo '# FILES=(/usr/lib/firmware/edid/edid.bin)' >> /etc/mkinitcpio.conf
echo '# HOOKS=(systemd base autodetect modconf block filesystems keyboard fsck sd-vconsole)' >> /etc/mkinitcpio.conf
nano /etc/mkinitcpio.conf
mkinitcpio -P
bootctl update
