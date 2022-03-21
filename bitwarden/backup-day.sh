#!/bin/bash

backup_time=`date +%Y%m%d%H%M`
content_msg="222.databases->oss://wuxiyuan/image/merger/===== Time:$backup_time"

#发送钉钉信息
function sendMsg(){
  res="$1"
  token="$2"
  getMsg $res
  curl "https://oapi.dingtalk.com/robot/send?access_token=$token" \
   -H 'Content-Type: application/json' \
   -d "$jsonData"
}

#获取发送信息的内容
function getMsg(){
echo "$content_msg"
    jsonData='
	  {  "msgtype": "markdown",
		 "markdown": {
			 "title":"#title",
			 "text": "# #title \n #content  \n   @17717812656 \n "
		 },
		 "at": {
			"atMobiles": [
				"17717812656"
			],
			"isAtAll": false
		}
	  }'
    jsonData="${jsonData//#title/$1}"
    jsonData="${jsonData//#content/$content_msg}"
}

#=======================================================================

echo $content_msg
#云端目录
oss_backup_dir=oss://wuxiyuan/image/merger/
#进入待备份的父目录
cd /home
#备份压缩文件写入的目录
backup_dir=backup-dir
backup_file=$backup_dir/day$backup_time.tar.gz
#生成压缩备份
tar -zcvf $backup_file --exclude=docker/kafka \
                       --exclude=docker/nexus3 \
                       --exclude=docker/jenkins/jenkinsdata/jobs/*/modules \
                       --exclude=docker/jenkins/jenkinsdata/workspace \
                       --exclude=model/tsl-temp/bim-docker \
                       docker model
#上传压缩备份
/etc/backup-oss/ossutil64 cp $backup_file $oss_backup_dir


if [ $? -ne 0 ];then
  sendMsg '备份失败' 'd2a14e3d1c52818b4230ef3e19be652312739841f6ef67bf20e1ae4906e1dc14'
else
  sendMsg '备份成功笔记' '2ea73c683a4da21d696abfd2c07be0eabbba220e11e28b55753250ba7c453183'
fi

#清理30天前的备份
find $backup_dir -mtime +30 -type f -name '*.gz' |xargs rm -rf

if [ $? -ne 0 ];then
	echo "=======清理失败 ===== Time:$backup_time"
else
	echo "清理成功 = Time:$backup_time"
fi


