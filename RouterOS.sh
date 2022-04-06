#!/bin/bash

# VPS2RouterOS
# https://github.com/Jamesits/vps2routeros
# This script will cause permanent data loss
# Please read the documentation prior to running this
# You have been warned

# ======================= please change these =================================
# your network interface to internet
# this is used to auto configure IPv4 after reboot
# (this may not work for every device)
# eth0 for most devices, ens3 for Vultr
# you can use `ip addr` or `ifconfig` to find out this
# default: the interface on the default route
MAIN_INTERFACE=$(ip route list | grep default | cut -d' ' -f 5)

# HDD device (not partition)
# May not be compatible with SCSI drives; see official document of RouterOS CHR
# you can use `lsblk` to find out this
# default: the disk with a partition mounted to `/`
DISK=$(mount | grep ' / ' | cut -d' ' -f1 | sed 's/[0-9]*$//g')

# get IPv4 address in IP-CIDR format
# do not modify unless you know what you are doing
ADDRESS=$(ip addr show $MAIN_INTERFACE | grep global | cut -d' ' -f 6 | head -n 1)

# get gateway IP
# do not modify unless you know what you are doing
GATEWAY=$(ip route list | grep default | cut -d' ' -f 3)

# URL to RouterOS CHR
ROUTEROS_URL=https://download.mikrotik.com/routeros/6.48.1/chr-6.48.1.img.zip

# Note: you can customize commands to be executed when RouterOS initializes.
# Search `Auto configure script` below
# do not modify that unless you know what you are doing

# ======================= no need to modify below ============================

set -euo pipefail

# check if this script is running under root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# https://stackoverflow.com/a/3232082/2646069
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

echo -e "Please confirm the settings:"
echo -e "Installation destination: ${DISK}"
echo -e "Network information:"
echo -e "\tinterface: ${MAIN_INTERFACE}"
echo -e "\tIPv4 address: ${ADDRESS}"
echo -e "\tIPv4 gateway: ${GATEWAY}"
echo -e "\nIf you continue, your disk will be formatted and no data will be preserved."

confirm || exit -1

echo "installing packages"
yum -y install wget

echo "download image"
wget ${ROUTEROS_URL} -O chr.img.zip

echo "unzip image"
gunzip -c chr.img.zip > chr.img

echo "mount image"
mount -o loop,offset=512 chr.img /mnt

echo "Get address and gateway and assign variable"

mkdir -p /mnt/rw
\echo "/ip address add address=${ADDRESS} interface=[/interface ethernet find where name=ether1]
/ip route add gateway=${GATEWAY}
" > /mnt/rw/autorun.scr

echo "Unmount the image"
umount /mnt

echo "Your old OS is being wiped while running, good luck"
echo "If the device stopped responding for more than 30 minutes, please issue a reboot manually"

sleep 5

echo "write disk"
echo u > /proc/sysrq-trigger

echo "sync disk"
dd if=chr.img bs=1024 of=${DISK}

echo "wait a while"
sleep 5 || echo "please wait 5 seconds and execute\n\techo b > /proc/sysrq-trigger\nmanually, or hard reset device"

echo "rebooting"
reboot
