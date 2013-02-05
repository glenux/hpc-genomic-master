#!/bin/sh

ARCH=i386
#ARCH=amd64
DISTRO=ubuntu
PXE_ROOT=/opt/pxe/$DISTRO-$ARCH
DNSMASQ_CONF=/opt/pxe/$DISTRO-$ARCH/dnsmasq.conf

sudo apt-get install dnsmasq syslinux memtest86+

# Creation du repertoire servi par le builtin tftp de dnsmasq
mkdir -p $PXE_ROOT/pxelinux.cfg
cd $PXE_ROOT

# On fetch le kernel, le bootloader pxe et le ramdisk
export SITEFTP=http://archive.ubuntu.com/ubuntu/dists/precise/main/installer-$ARCH/current/images/netboot/ubuntu-installer/i386

wget -c $SITEFTP/pxelinux.0 -O $PXE_ROOT/pxelinux.0

wget -c $SITEFTP/linux -O $PXE_ROOT/linux
wget -c $SITEFTP/initrd.gz -O $PXE_ROOT/initrd.gz


# Config du bootloader
cat > $PXE_ROOT/pxelinux.cfg/default << EOF
DEFAULT $DISTRO
LABEL $DISTRO
        kernel linux
        append vga=normal initrd=initrd.gz --
TIMEOUT 0
EOF

# Config dnsmasq
cat > $DNSMASQ_CONF << EOF
interface=eth0
enable-tftp
tftp-root=$PXE_ROOT
dhcp-range=10.42.0.10,10.42.0.50,255.255.255.0
dhcp-boot=pxelinux.0,pxeserver,10.42.0.1
EOF

echo 1 |sudo cat > /proc/sys/net/ipv4/ip_forward
sudo ifconfig eth0 10.42.0.1 netmask 255.255.255.0
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

# Reload dnsmasq
sudo /etc/init.d/dnsmasq stop
sudo dnsmasq \
        --keep-in-foreground \
        --conf-file=$DNSMASQ_CONF \
        --dhcp-authoritative \
        --log-queries \
        --log-facility=-