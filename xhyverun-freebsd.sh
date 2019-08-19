#!/bin/sh

UUID_VM_ID="3A9C72E1-0E2E-4380-9C2B-A571B7B5DF8E"

ACPI="-A"
MEM="-m 2G"
SMP="-c 2"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
PCI_NETWORK_CARD="-s 2:0,virtio-net"
LPC_DEV="-l com1,stdio"
KERNELENV=""

BOOTVOLUME=""
ISO_IMG="/Volumes/localzfs/Temp/xhyve/FreeBSD-12.0-RELEASE-amd64-bootonly.iso"
ROOT_IMG="/Volumes/localzfs/Temp/xhyve/root.ufs.img"
ZFS_IMG="/Volumes/localzfs/Temp/xhyve/data.zfs.img"

PCI_CDROM="    -s 3:0,ahci-cd,${ISO_IMG}"
PCI_HDD_ROOT=" -s 4:0,virtio-blk,${ROOT_IMG}"
PCI_HDD_ZFS="  -s 5:0,virtio-blk,${ZFS_IMG}"

if [[ -z "${STARTUP_IMG}" ]]; then
    export STARTUP_IMG=${ROOT_IMG}
fi

BOOT_COMMAND="-f fbsd,test/userboot.so,${STARTUP_IMG},\"${KERNELENV}\""

PATH="build/Release:build:$PATH"

#
# Depending on which we wanna bot first ( 3:0,virtio-blk,$IMG or 4:0,ahci-cd,$BOOTVOLUME  )
# depends on their order, and of course the PCIe num:0 identifier in the start of both of them.
#

   # -s 5:0,ahci-cd,$BOOTVOLUME \
xhyve -U $UUID_VM_ID \
    $ACPI $SMP $MEM $PCI \
    $PCI_NETWORK_CARD \
    $PCI_HDD_ROOT $PCI_HDD_ZFS $PCI_CDROM \
    $LPC_DEV \
    $BOOT_COMMAND



