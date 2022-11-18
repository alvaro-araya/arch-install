#!/bin/bash
cd ~
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -fR paru
