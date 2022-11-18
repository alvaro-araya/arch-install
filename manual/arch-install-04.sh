#!/bin/bash

cat << 'EOF' > /etc/udev/rules.d/99-ite8291.rules
SUBSYSTEMS=="usb", ATTRS{idVendor}=="048d", ATTRS{idProduct}=="6006", MODE:="0666"
EOF

mkdir /etc/rgb
cat << 'EOF' > /etc/rgb/rgb.sh
#!/bin/bash
ite8291r3-ctl anim --file /etc/rgb/rgb.colors
ite8291r3-ctl brightness 50
# lightbar_rgb:3 max 36
echo 0 > /sys/class/leds/lightbar_rgb:3:status/brightness
# lightbar_rgb:2 max 36
echo 0 > /sys/class/leds/lightbar_rgb:2:status/brightness
# lightbar_rgb:1 max 36
echo 36 > /sys/class/leds/lightbar_rgb:1:status/brightness
# lightbar_animation max 1
# echo 0 > /sys/class/leds/lightbar_animation::status/brightness
EOF
chmod 755 /etc/rgb/rgb.sh
cat << 'EOF' > /etc/rgb/rgb-low.sh
#!/bin/bash
ite8291r3-ctl monocolor --name green --brightness 10
# lightbar_rgb:3 max 36
echo 0 > /sys/class/leds/lightbar_rgb:3:status/brightness
# lightbar_rgb:2 max 36
echo 0 > /sys/class/leds/lightbar_rgb:2:status/brightness
# lightbar_rgb:1 max 36
echo 0 > /sys/class/leds/lightbar_rgb:1:status/brightness
# lightbar_animation max 1
# echo 0 > /sys/class/leds/lightbar_animation::status/brightness
EOF
chmod 755 /etc/rgb/rgb-low.sh
echo 'RGB colors'
cp rgb.colors /etc/rgb

echo 'RGB'
cat << 'EOF' > /etc/systemd/system/rgb.service
[Unit]
Description=XPG-RGB
[Service]
ExecStart=/etc/rgb/rgb.sh
[Install]
WantedBy=multi-user.target
EOF

systemctl enable rgb.service

echo 'Pipewire'
mkdir /etc/pipewire
cp pipewire.conf /etc/pipewire

echo 'Docker'
echo 'options overlay metacopy=off redirect_dir=off' > /etc/modprobe.d/overlay.conf
