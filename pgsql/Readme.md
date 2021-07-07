# 单机版搭建
直接启动 ./docker-compose.yml 即可

* 配置连接数: command: "postgres -c 'max_connections=10800'" 
  * 添加到文件末尾即可, 相当与修改了启动命令.
* docker-compose up -d
* 使用的镜像: https://hub.docker.com/r/timescale/timescaledb
  * https://docs.timescale.com/timescaledb/latest/how-to-guides/install-timescaledb/self-hosted/docker/installation-docker/
  * 基于的镜像: https://hub.docker.com/_/postgres

# 主从搭建

## 单主从复制
1. 按照对应master和slave中的步骤创建容器即可.
2. 先创建master, 然后创建slave.

## 高可用
参考链接:   
https://app.yinxiang.com/shard/s9/nl/16674383/12482a19-cb4f-4ca1-aeb3-0c8d18b54ee0  
https://github.com/guozizi/pg_cluster
1. master只做两个配置.
2. pg_hba.conf 加入从节点ip
3. 添加从节点用户.
4. 从节点按照步骤配置, 并修改 pg_hba.conf 文件中的ip.
5. 把pgpool中的 id_rsa.pub 拷贝到对应机器做免密登陆.
6. 修改./pgpool/docker-compose.yml 中的对应ip.
7. 启动pgpool.




### 问题
1. 查询节点信息. 进入容器执行命令;
```shell
psql -h localhost -p 5432 -U postgres postgres -c "show pool_nodes"
```
2. 从节点升级为主节点
failover.sh 是在主节点下线是启用从节点为主节点.
主要使用下面sql,有三种方式升级从为主节点.下面是其中二种.
```shell
# 第一种
/usr/pgsql-12/bin/pg_ctl promote -D /var/lib/pgsql/12/data
# 第二种
select pg_promote(true,60)
```
3. 主节点重启为从节点
   以“postgres”用户创建“/app/pgsql/data/standby.signal”文件，添加内容：standby_mode = 'on'
   然后同步一下主库的数据: rsync -r slave/ root@192.168.130.77:/home/twdt/docker/postgresql/data/psql/master/
   同步后修改 postgresql.auto.conf 文件中的IP地址. 然后启动数据库. 
4. 如果重启主节点仍然当主库使用

* 停止所有服务
  删除“/app/pgsql/data/standby.signal”文件
  启动服务
* 当前主库：

  以“postgres”用户创建“/app/pgsql/data/standby.signal”文件，添加内容：standby_mode = 'on'
  启动服务

5. 重启主库为从库后 pgpool 查询节点一直是down的状态.  
   pgpool 无法自动识别恢复机制,需要手动操作.
   1. 删除 /var/log/postgresql/pgpool_status
   2. 重启 pgpool 服务,docker-compose restart
   3. 参考https://app.yinxiang.com/shard/s9/nl/16674383/d7e94f01-7de4-493c-98be-2c5554e3accb

6. 真机安装参考  
   https://app.yinxiang.com/shard/s9/nl/16674383/f4b6da9d-e306-4a79-a203-7e04802f1518


7. pgpool-II 手册  
   中文使用配置介绍  
   https://www.pgpool.net/docs/pgpool-II-3.5.4/doc/pgpool-zh_cn.html

8. 搭建教程参考  
   https://app.yinxiang.com/shard/s9/nl/16674383/380adc1f-7be9-41a6-9c39-d6ea2bcf409d

9. 详细的主从介绍, 略深入,待细看.  
   https://app.yinxiang.com/shard/s9/nl/16674383/0fa0d9e8-80b7-47ec-80cf-16e8086878b3


10. pgpool 偶尔出现连不上, 需要重启容器.
    pgpool-bitnami 这个镜像不能使用, 无法做到ha, 挂了一个就不能用了, 重启也不能做到副节点转主节点. 
    
    ======结论: 要么自己制作镜像. 要么不适用pgpool了. 正常情况主从就行了, 在高点要求就用VIP做HA.=========

