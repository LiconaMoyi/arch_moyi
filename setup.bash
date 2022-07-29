ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo Y | sudo pacman -Sy vim
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
127.0.0.1 $HOST_NAME.localdomain $HOSTNAME
" > /etc/hosts
