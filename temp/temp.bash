export PWD="1q!Q3115"
export Y="Y"
echo $Y | sudo pacman -Sy xorg-xinit xorg-server awesome 
#xterm
sudo pacman -Sy linux-lts linux-headers
sudo pacman -Sy cmake ninja
git config --global http.proxy 127.0.0.1:7890
git config --global https.proxy 127.0.0.1:7890
sudo pacman -Sy gdb
sudo pacman -Sy unzip
sudo pacman -Sy blender
# vscode-can not login
sudo xdg-settings set default-url-scheme-handler vscode code-url-handler.desktop
sudo pacman -S gnome-keyring libsecret

sudo pacman -Sy locate
sudo pacman -Sy ranger
#sudo pacman -Sy terminus-font
#sudo pacman -Sy firefox
#sudo pacman -Sy fcitx-im fcitx-configtool rime
#sudo pacman -Sy expect

