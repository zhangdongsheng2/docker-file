#启动命令
1. 修改 config.env.sh 中的数据库地址和zookeeper地址
2. check脚本是检查服务数和前端服务是否存活.
3. docker-stack是 docker-swarm的文件.

启动之前先执行数据库初始化, 文件在apache-dolphinscheduler-1.3.6-src\sql\dolphinscheduler_postgre.sql


#有很多的不方便, 建议真机部署.
* Spark Hive HDFS 都不能直接操作建议真机部署然后做相应的配置.
