#!/bin/bash
echo 'Paquetes de Pacman'
pacman -S xorg xorg-server xorg-xinit glxinfo  \
kitty gnome archlinux-wallpaper easyeffects piper \
openvpn networkmanager-l2tp networkmanager-openvpn iperf net-tools nmap dnsutils \
ghostwriter wget htop lsd pwgen fuse bat ncdu grc libreoffice-fresh hunspell hunspell-es_cr \
remmina archlinux-keyring docker docker-compose mtr remmina freerdp ipcalc neofetch xclip mirage

# todo: GNOME
echo 'Gnome-Session'
cat << 'EOF' >> /home/xyz/.xinitrc
exec gnome-session
EOF

echo 'paru optimus-manager'
echo 'Agregar como script de arranque'
echo '/usr/bin/prime-offload'
echo 'Copia el archivo optimus-manager.conf al /etc/optimus-manager/'

echo 'Agregar en .zshrc'
echo 'if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then'
echo 'exec startx -- vt1 &> /dev/null'
echo 'fi'

echo 'paru 1password'
echo 'paru gdm-prime'
echo 'paru anydesk'
echo 'paru atkinson-hyperlegible-fonts'
echo 'paru cdm'
echo 'paru cli-visualizer'
echo 'paru console-tdm'
echo 'paru drawio-desktop'
echo 'paru filezilla'
echo 'paru flameshot'
echo 'paru google-chrome'
echo 'paru google-cloud-sdk'
echo 'paru jetbrainsmono'
echo 'paru linphone-desktop'
echo 'paru mirage'
echo 'paru mysql-workbench-community'
echo 'paru nerd-fonts-hack'
echo 'paru optimus'
echo 'paru papirus'
echo 'paru postman'
echo 'paru remmina'
echo 'paru remmina-plugin-rdesktop'
echo 'paru signal-desktop'
echo 'paru ookla-speedtest-bin'
echo 'paru spotify'
echo 'paru ttf-droid'
echo 'paru ttf-meslo'
echo 'paru visual-studio-code-bin'
echo 'paru xlib'
echo 'paru zoom'

# curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
# echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
# pacman -Syu sublime-text
# pacman -Syu sublime-merg
