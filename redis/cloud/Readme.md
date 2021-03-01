# Redis集群
* 要想搭建一个最简单的Redis集群，那么至少需要6个节点：
  3个Master和3个Slave。为什么需要3个Master呢？如果你了解过Hadoop/Storm/Zookeeper这些的话，
  你就会明白一般分布式要求基数个节点，这样便于选举（少数服从多数的原则）。

```shell
# 1. 拷贝文件到服务器, 三台服务器每个服务器两个节点
# 2. 执行启动命令
docker-compose up -d
# 3. 关联容器创建集群, 进入容器执行命令
redis-cli -a twdt8888 --cluster create 192.168.130.73:6373 192.168.130.73:6377 192.168.130.77:6373 192.168.130.77:6377 192.168.130.78:6373 192.168.130.78:6377 --cluster-replicas 1

```
# 注意
1. 切换数据库报错: ERR SELECT is not allowed in cluster mode 
   * redis集群版只使用db0，select命令虽然能够支持select 0。其他的db都会返回错误。