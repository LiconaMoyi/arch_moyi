# import system variables
source config.bash
source utils/common.bash

network
if [ $? != "1" ]; then
# @TODO: try to connnect network
echo "please connect to network first"
exit 0
fi

fdisk -l | grep "^Disk /dev/[sh]d[a-z]" | awk  '{print $2}' | sed "s@:@@g"
read -p "Your choice PARTDISK above(quit to exit):" PARTDISK
echo "$PARTDISK"
if [ $PARTDISK == quit ];then
  echo "quit..."
  exit 0
fi

echo "select the method you want to use to format disk:
1:use config file, 
2:use the system portion-BOOT:512M, SWAP:memory capacity, HOME:70% remaning, ROOT:30% remaining:"
read FORMAT_SELECTION

case $FORMAT_SELECTION in
    1)
        echo "you choose 1, continue"
        ;;
    2)
        BOOT_SIZE="512M"
        MemTotal=$(cat /proc/meminfo |grep 'MemTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
        SWAP_SIZE=$MemTotal
        DISK_SIZE=$(fdisk -l | grep "Disk ${PARTDISK}" | awk -F , '{print $1}' | awk -F : '{print $2}' | sed 's/[ ]*//g' | awk -F G '{print $1}')
        DISK_INFO=$(fdisk -l | grep "Disk ${PARTDISK}" | awk -F , '{print $1}' | awk -F : '{print $2}' | sed 's/[ ]*//g')
        echo "disk_size: $DISK_SIZE, disk_unit: $DISK_UNIT"
        HOME_SIZE=`echo "$DISK_SIZE * 0.7" | bc`${DISK_INFO:0-3}
        ROOT_SIZE=`echo "$DISK_SIZE * 0.3" | bc`${DISK_INFO:0-3}
        echo "BOOT_SIZE: $BOOT_SIZE,"
        echo "SWAP_SIZE: $SWAP_SIZE,"
        echo "HOME_SIZE: $HOME_SIZE,"
        echo "ROOT_SIZE: $ROOT_SIZE,"
        sleep 3
        ;;
    *)
        echo "error"
        exit 0
esac
until fdisk -l | grep -o "^Disk /dev/[sh]d[a-z]" | grep "^Disk ${PARTDISK}$" &> /dev/null ;do
  read -p "wrong choice Your choice again:" PARTDISK
done
  read -p "Will destroy all data continue[y/n]:" CHOICE
until [ $CHOICE == "y" -o $CHOICE == "n" ];do
  read -p "Will destroy all data continue[y/n]:" CHOICE
done
[ $CHOICE == n ] && echo "quit..." && exit 0;
for DISK in `mount | grep "/dev/[sh]d[a-z]" | awk '{print $1}'`;do
fuser -km $DISK
umount $DISK && echo "$DISK umount ok"
done
swapoff $(swapon | grep "$PARTDISK" | awk -F' ' '{print $1}')

dd if=/dev/zero of=$PARTDISK bs=512 count=1&>/dev/null
partprobe $PARTDISK
sync&>/dev/null
sleep 2
# BOOT_SIZE,SWAP_SIZE,HOME_SIZE,ROOT_SIZE
echo "n
p
1

+${BOOT_SIZE}
n
p
2

+${SWAP_SIZE}
n
p
3

+${ROOT_SIZE}
n
p


w"|fdisk $PARTDISK &>/dev/null
partprobe $PARTDISK

# partition format
mkfs.fat -F32 ${PARTDISK}1
mkswap ${PARTDISK}2
swapon ${PARTDISK}2
echo Y | mkfs.ext4 ${PARTDISK}3
echo Y | mkfs.ext4 ${PARTDISK}4
# mount partition
mount ${PARTDISK}4 /mnt
if [ -d /mnt/boot/EFI  ];then
  echo /mnt/boot/EFI exist
else
  mkdir -p /mnt/boot/EFI
fi
mount ${PARTDISK}1 /mnt/boot/EFI
if [ -d /mnt/home  ];then
  echo /mnt/home exist
else
  mkdir /mnt/home
fi
mount ${PARTDISK}3 /mnt/home
# replace domestic image
reflector -c China -a 5 --sort rate --save /etc/pacman.d/mirrorlist
echo Y | sudo pacman -Sy archlinux-keyring
pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab
# enter the new system
cp setup.bash /mnt
arch-chroot /mnt

