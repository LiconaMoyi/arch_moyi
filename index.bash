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
sudo pacman -Sy expect
echo "current Env:"
echo $SYS_ENV