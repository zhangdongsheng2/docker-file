#如果安装失败参考如下
* 执行如下命令更改系统可打开的文件数. 

# 修改系统文件配合配置
```shell
[root@eip data]#  vim /etc/security/limits.conf
....
* soft nofile 65536
* hard nofile 65536

[root@eip data]#  vim  /etc/sysctl.conf
vm.max_map_count=655360
```
# 运行命令使其配置生效
[root@eip data]#  sysctl ‐p

如果报错执行如下命令
```shell
modprobe br_netfilter
ls /proc/sys/net/bridge
sysctl -p
```



