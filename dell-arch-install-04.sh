#!/bin/bash

echo 'Pipewire'
mkdir /etc/pipewire
cp pipewire.conf /etc/pipewire

echo 'Docker'
echo 'options overlay metacopy=off redirect_dir=off' > /etc/modprobe.d/overlay.conf
