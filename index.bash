source utils/base.bash
network
if [ $? != "1" ]; then
# @TODO: try to connnect network
echo "请先连接到网络"
exit 0
fi
echo "执行虚拟机所要"