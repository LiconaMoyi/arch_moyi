source ../../utils/base.bash
network
if [ $? -eq 0 ];then
	echo "please connect to network first"
	exit -1
else echo "connect to network successfully"
fi
