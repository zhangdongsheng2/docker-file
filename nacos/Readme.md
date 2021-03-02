keepalived 2个 高可用 + Nginx2个 负载均衡 + 3个Nacos
1. Nginx挂有VIP切换. nginx高可用.
2. Nacos挂有服务注册重试机制, 有一个节点可用即可.

# Mysql数据库脚本
https://github.com/alibaba/nacos/blob/master/distribution/conf/nacos-mysql.sql

# Nacos配置
配置文件 application.properties
添加指定IP的配置
nacos.inetutils.ip-address=192.168.130.78

参考命令如下, 因为容器修改文件就会停止,所以用追加的方式,然后重新启动容器.
容器要采用host模式的网络, 因为nacos绑定IP如果容器的网络IP属于容器内网.
```shell
cat << EOF >> conf/application.properties
nacos.inetutils.ip-address=192.168.130.78
EOF
```


# Nginx配置
```nginx
upstream cluster{
	server 192.168.130.73:8848;
	server 192.168.130.77:8848;
	server 192.168.130.78:8848;
}   

server {
	listen      8838;
	server_name  _;

	#charset koi8-r;

	#access_log  logs/host.access.log  main;

	location / { 
	   # root   html;
	   # index  index.html index.htm;
	   proxy_pass http://cluster;
	}
}
```
# Keepalived配置
安装 yum install keepalived –y
安装 killall: yum install psmisc

修改配置文件/etc/keepalived/keepalivec.conf 配置文件
1. 主节点
```keepalived
! Configuration File for keepalived

global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.130.79
   smtp_connect_timeout 30   #切换时发送邮件通知
   router_id LVS_DEVEL
}

vrrp_script chk_http_port {
	script "/home/twdt/script/nginx_check.sh"
	interval 2 #（检测脚本执行的间隔）
	weight 2
}

vrrp_instance VI_1 {
    state MASTER  # 备份服务器上将 MASTER 改为 BACKUP
    interface ens192  //网卡
    virtual_router_id 33  # 主、备机的 virtual_router_id 必须相同
    priority 100  # 主、备机取不同的优先级，主机值较大，备份机值较小
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.130.80  // VRRP H 虚拟地址
    }
}
```
2. 备用节点
```vip
! Configuration File for keepalived

global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.130.79
   smtp_connect_timeout 30
   router_id LVS_DEVEL
}

vrrp_script chk_http_port {
	script "/home/twdt/script/nginx_check.sh"
	interval 2 #（检测脚本执行的间隔）
	weight 2
}

vrrp_instance VI_1 {
    state BACKUP
    interface ens192
    virtual_router_id 33
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.130.80
    }
}
```

检测nginx容器的脚本, nginx停止就关闭keepalived,虚拟IP就切换到备用节点
```shell
#!/bin/bash
A=`docker inspect --format '{{.State.Running}}' basic-nginx`
if [ $A ];then
    docker-compose -f /home/twdt/docker/nginx/docker-compose.yml up -d
    sleep 2
    if [ `docker inspect --format '{{.State.Running}}' basic-nginx` ];then
        killall keepalived
    fi
fi
```


注意  
1. keepalived vip 生成了ping不通问题？  
主要是在配置文件（/etc/keepalived/keepalived.conf）里注释掉（vrrp_strict）此关键字就可以了。

