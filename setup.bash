ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo Y | sudo pacman -Sy vim expect
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sed -i 's/#zh_CN.UTF-8/zh_CN.UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "input the hostname you want to use:"
read HOST_NAME
echo $HOST_NAME > /etc/lcoale.conf
# set hosts
echo "
127.0.0.1 localhost
::1 localhost
127.0.0.1 $HOST_NAME.localdomain $HOST_NAME
" > /etc/hosts
echo "input the root password you want to use:"
read ROOT_PASSWORD
expect<<-EOF
passwd
expect "New password" {send "${ROOT_PASSWORD}\n";exp_continue}
expect "Retype new password" {send "${ROOT_PASSWORD}\n";}
EOF
echo "set root password successfully"
echo "input the group name you want to use:"
read GROUP_NAME
groupadd $GROUP_NAME
echo "add group successfully"
echo "input the user name you want to use:"
read USER_NAME
useradd $USER_NAME -g $GROUP_NAME -m
echo "input the user password you want to use:"
read USER_PASSWORD
expect<<-EOF
passwd $USER_NAME
expect "New password" {send "${USER_PASSWORD}\n";exp_continue}
expect "Retype new password" {send "${USER_PASSWORD}\n";}
EOF
