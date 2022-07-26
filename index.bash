# import system variables
source config.bash
source utils/base.bash

network
if [ $? != "1" ]; then
# @TODO: try to connnect network
echo "please connect to network first"
exit 0
fi
echo "install expect to do more"
echo Y | sudo pacman -Sy expect
echo "current Env: $SYS_ENV"

echo "start initialize disk"
lsblk
echo "input the disk you want to use"
read DISK_NAME
echo "you select $DISK_NAME, are you sure you want to format it?(Y/N):"
read FORMAT_STATUS
if [ $FORMAT_STATUS != "Y" ]; then
echo "please rerun this shell script"
exit 0
fi
expect<<-EOF
spawn fdisk /dev/$DISK_NAME               // run process and trace it
expect {
"m for help" {sends "n\n";exp_continue}      // capture the output of spawn, and input a string to the process if it matches the expected character
"default p" {send "p\n";exp_continue}        // n is the new partition, \n is enter, p is the main partition, and then enter
"default 1" {send "1\n";exp_continue}        // partition number
"default 2048" {send "\n";exp_continue}      // partition size
"+/-sizes" {send "+10G\n";exp_continue}
}

expect "m for help" {send "p\n";send "wq\n";exp_continue}   //p显示已建分区，wq保存配置，注意exp_continue，否则无法继续输入wq
EOF
# mkdir /data    //新建挂载目录
# fdisk -l   
# mkfs.xfs /dev/$DISK_NAME   //格式化
# mount /dev/$DISK_NAME /data    //挂载使用
# df -Th
