source ../../utils/base.bash
network
if [ $? -eq 0 ];then
	echo "网络不畅通，请检查网络设置！"
	exit -1
else echo "网络畅通，你可以上网冲浪！"
fi
