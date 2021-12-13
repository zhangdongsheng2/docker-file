#!/bin/bash

# Docker 部署的备份
# 以下配置信息请自己修改
pgsql_user="postgres" #pgsql备份用户
pgsql_docker="pgsql"
backup_db_arr=("giot" "nacos-chongqing") #要备份的数据库名称，多个用空格分开隔开 如("db1" "db2" "db3")

backup_location=/var/lib/postgresql/data/.backup #备份数据存放位置，末尾请不要带"/",此项可以保持默认，程序会自动创建文件夹
expire_backup_delete="ON" #是否开启过期备份删除 ON为开启 OFF为关闭
expire_days=7 #过期时间天数 默认为三天，此项只有在expire_backup_delete开启时有效


#================本行开始以下不需要修改======================
backup_time=`date +%Y%m%d%H%M` #定义备份详细时间
backup_Ymd=`date +%Y-%m-%d` #定义备份目录中的年月日时间
#backup_7ago=`date -d '7 days ago' +%Y-%m-%d` #7天之前的日期
backup_dir=$backup_location/$backup_Ymd #备份文件夹全路径
welcome_msg="Welcome to use pgsql backup tools!" #欢迎语

# 判断pgsql的容器是否启动,pgsql没有启动则备份退出
pgsql_ps=`docker ps --format={{.Names}} | grep $pgsql_docker | wc -l`

if [ $pgsql_ps == 0 ]; then
echo "ERROR:pgsql is not running! backup stop!"
exit
else
echo $welcome_msg
fi

# 判断有没有定义备份的数据库，如果定义则开始备份，否则退出备份
if [ "$backup_db_arr" != "" ];then
#dbnames=$(cut -d ',' -f1-5 $backup_database)
#echo "arr is (${backup_db_arr[@]})"
for dbname in ${backup_db_arr[@]}
do
echo "database $dbname backup start..."

docker exec -u$pgsql_user -it $pgsql_docker /bin/bash -c "mkdir -p $backup_dir"
docker exec -u$pgsql_user -it $pgsql_docker /bin/bash -c "pg_dump --dbname $dbname --verbose --format=t --blobs --schema 'public'  >  $backup_dir/$dbname-$backup_time.tar"
flag=`echo $?`

if [ $flag == "0" ];then
echo "database $dbname success backup to $backup_dir/$dbname-$backup_time.sql.gz"
else
echo "database $dbname backup fail!"
fi

done
else

echo "ERROR:No database to backup! backup stop"
exit

fi

# 如果开启了删除过期备份，则进行删除操作
if [ "$expire_backup_delete" == "ON" -a "$backup_location" != "" ];then
#`find $backup_location/ -type d -o -type f -ctime +$expire_days -exec rm -rf {} \;`
docker exec -uroot -it $pgsql_docker /bin/bash -c "find $backup_location/ -type d -mtime +$expire_days | xargs rm -rf"
echo "Expired backup data delete complete!"
fi
echo "All database backup success! Thank you!"
exit
fi
