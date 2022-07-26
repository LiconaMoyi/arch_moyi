source utils/base.bash
network
if [ $? != "1" ]; then
# @TODO: try to connnect network
echo "please connect to network first"
exit 0
fi
echo "continue to do other work"