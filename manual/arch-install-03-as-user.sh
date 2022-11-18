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
