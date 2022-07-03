#!/bin/bash
# 脚本有问题直接退出
set -e

runStr="java -server -Xms${XMS}M -Xmx${XMS}M -Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF-8 -XX:+HeapDumpOnOutOfMemoryError -jar /app/app.jar"

if [ -n $WAIT_FOR ];then
	IFS=';'
	waitStr=''
	# 生成依赖检查命令, 多个host连续检查
  for line in $WAIT_FOR
      do
        waitStr="${waitStr} wait-for-it.sh -t 300 $line --"
      done
  runStr="$waitStr $runStr"
fi
/bin/bash -c "$runStr"


