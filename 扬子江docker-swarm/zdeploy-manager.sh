#!/bin/bash

read -p "需要发布版本的完整镜像名： " a

#获取标签前面的名字，如ms-yangzi
b=`echo $a|awk -F '[/ :]+' '{print $3}'`

#获取仓库地址，如registry.cn-hangzhou.aliyuncs.com/iothub-test
address=`echo $a|awk -F '/' '{print $1"/"$2}'`

#判断需要发布的文件是否存在
if [ -f "/home/docker/$b.yml" ];then


########获取最近需要发布的新版本号(标签)
	nver=`echo $a|awk -F '[/ :]+' '{print $4}'`

########获取老的版本号标签
	over=`cat /home/docker/$b.yml|grep image|awk -F":" '{print $3}'`




	echo
########备份yml文件
	echo -n "cp $b.yml........"
	sudo cp $b.yml  bak/$b.yml.`date +%F`
	echo 'done!'

########修改yml文件里的版本号标签
	echo -n "modify $b.yml......."
	sudo sed -i s#$address/$b:$over#$address/$b:$nver#g  $b.yml
	echo 'done!'

########删除service
	echo -n "remove service & container........ "
	docker service ls |grep $b|awk '{print $1}'|xargs docker service rm  > /dev/null
	echo "done!"


########启动service和docker
	echo -n "create service  & run container....... "
	docker stack deploy  $b -c $b.yml --with-registry-auth
	echo "done!"
	echo

	echo "finish!"
	echo
else
	echo "yml文件不存在，需要创建文件后发布"
fi
