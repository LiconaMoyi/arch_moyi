# # import system variables
# source config.bash
# source utils/base.bash

# network
# if [ $? != "1" ]; then
# # @TODO: try to connnect network
# echo "please connect to network first"
# exit 0
# fi
# echo "install expect to do more"
# echo Y | sudo pacman -Sy expect
# echo "current Env: $SYS_ENV"

# echo "start initialize disk"
# lsblk
# echo "input the disk you want to use"
# read DISK_NAME
# echo "you select $DISK_NAME, are you sure you want to format it?(Y/N):"
# read FORMAT_STATUS
# if [ $FORMAT_STATUS != "Y" ]; then
# echo "please rerun this shell script"
# exit 0
# fi

# echo "select the method you want to use to format disk(1:use config file, 2:use the system portion-BOOT:512M,SWAP:memory capacity,
#       HOME:70% remaning,ROOT:30% remaining):"
# read FORMAT_SELECTION

# case $FORMAT_SELECTION in
#     1)
#         echo "you choose 1, continue"
#         ;;
#     2)
#         BOOT_SIZE="512M"
#         MemTotal=$(cat /proc/meminfo |grep 'MemTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
#         SWAP_SIZE=$MemTotal
#         DISK_SIZE=$(fdisk -l | grep 'Disk /dev/sda' | awk -F , '{print $1}' | awk -F : '{print $2}' | sed 's/[ ]*//g' | awk -F G '{print $1}')
#         DISK_INFO=$(fdisk -l | grep 'Disk /dev/sda' | awk -F , '{print $1}' | awk -F : '{print $2}' | sed 's/[ ]*//g')
#         echo "disk_size: $DISK_SIZE, disk_unit: $DISK_UNIT"
#         HOME_SIZE=`echo "$DISK_SIZE * 0.7" | bc`${DISK_INFO:0-3}
#         ROOT_SIZE=`echo "$DISK_SIZE * 0.3" | bc`${DISK_INFO:0-3}
#         echo "BOOT_SIZE: $BOOT_SIZE,"
#         echo "SWAP_SIZE: $SWAP_SIZE,"
#         echo "HOME_SIZE: $HOME_SIZE,"
#         echo "ROOT_SIZE: $ROOT_SIZE,"
#         sleep 3
#         ;;
#     *)
#         echo "error"
# esac
# BOOT_SIZE,SWAP_SIZE,HOME_SIZE,ROOT_SIZE

# expect<<-EOF
# spawn fdisk /dev/$DISK_NAME
# expect "m for help" {send "g\n";}

# expect {
#   "m for help" {send "n\n";exp_continue}
#   "default p" {send "p\n";exp_continue}
#   "default 1" {send "1\n";exp_continue}
#   "default 2048" {send "\n";exp_continue}
#   "+/-size" {send "+$BOOT_SIZE\n";}
#   "remove the signature" {send "Y\n";exp_continue}
# }
# expect {
#   "m for help" {send "n\n";exp_continue}
#   "Partition number" {send "2\n";exp_continue}
#   "First sector" {send "\n";exp_continue}
#   "Last sector" {send "+8G\n";}
#   "remove the signature" {send "Y\n";exp_continue}
# }

# expect {
#   "m for help" {send "n\n";exp_continue}
#   "Partition number" {send "3\n";exp_continue}
#   "First sector" {send "\n";exp_continue}
#   "Last sector" {send "+$HOME_SIZE\n";}
#   "remove the signature" {send "Y\n";exp_continue}
# }

# expect {
#   "m for help" {send "n\n";exp_continue}
#   "Partition number" {send "4\n";exp_continue}
#   "First sector" {send "\n";exp_continue}
#   "Last sector" {send "\n";exp_continue}
#   "remove the signature" {send "Y\n";}
# }

# expect "m for help" {send "p\n";send "wq\n";exp_continue}
# EOF

# # @TODO get the disk partition by fdisk -l
# BOOT_DEVICE=/dev/${DISK_NAME}1
# SWAP_DEVICE=/dev/${DISK_NAME}2
# ROOT_DEVICE=/dev/${DISK_NAME}3
# HOME_DEVICE=/dev/${DISK_NAME}4

# # partition format
# mkfs.fat -F32 $BOOT_DEVICE
# mkswap $SWAP_DEVICE
# swapon $SWAP_DEVICE
# mkfs.ext4 $ROOT_DEVICE
# mkfs.ext4 $HOME_DEVICE
# # mount partition
# mount $ROOT_DEVICE /mnt
# mkdir -p /mnt/boot/EFI
# mount $BOOT_DEVICE /mnt/boot/EFI
# mkdir /mnt/home
# mount $HOME_DEVICE /mnt/home
# # replace domestic image
# reflector -c China -a 5 --sort rate --save /etc/pacman.d/mirrorlist
expect<<-EOF
pacstrap /mnt base base-devel linux linux-firmware
expect "Do you want to delete it" {send "Y\n";exp_continue}
EOF

genfstab -U /mnt >> /mnt/etc/fstab
# enter the new system
arch-chroot /mnt


