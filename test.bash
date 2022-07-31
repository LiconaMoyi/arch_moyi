#!/bin/bash
#

fdisk -l | grep "^Disk /dev/[sh]d[a-z]" | awk  '{print $2}' | sed "s@:@@g"
read -p "Your choice PARTDISK above:" PARTDISK
if [ $PARTDISK == quit ];then
  echo "quit..."
  exit 0
fi
until fdisk -l | grep -o "^Disk /dev/[sh]d[a-z]" | grep "^Disk ${PARTDISK}$"&>/dev/null ;do
  read -p "wrong choice Your choice again:" PARTDISK
done
  read -p "Will destroy all data continue[y/n]:" CHOICE
until [ $CHOICE == "y" -o $CHOICE == "n" ];do
  read -p "Will destroy all data continue[y/n]:" CHOICE
done
[ $CHOICE == n ] && echo "quit..." && exit 0;
for DISK in `mount | grep "/dev/sdb" | awk '{print $1}'`;do
fuser -km $DISK
umount $DISK && echo "$DISK umount ok"
done
dd if=/dev/zero of=$PARTDISK bs=512 count=1&>/dev/null
partprobe $PARTDISK
sync&>/dev/null
sleep 2
echo 'n
p
1

+20M
n
p
2

+512M
n
p
3

+128M
t
3
82
w'|fdisk $PARTDISK &>/dev/null
partprobe $PARTDISK
sync &>/dev/null
sleep 2
mke2fs ${PARTDISK}1 &>/dev/null && echo "${PARTDISK}1finished"
sync &>/dev/null
sleep 2
mke2fs ${PARTDISK}2 &>/dev/null && echo "${PARTDISK}2finished"
ssync &>/dev/null
sleep 2
mkswap ${PARTDISK}3 &>/dev/null && echo "${PARTDISK}3finished"
sync &>/dev/null
sleep 2