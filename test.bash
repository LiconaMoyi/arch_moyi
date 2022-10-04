#! /bin/bash
pacman -Sy dosfstools grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=Arch linux
grub-mkconfig -o /boot/grub/grub.cfg
sudo pacman -Sy iwd
systemctl enable iwd
exit
umount -R /mnt
reboot