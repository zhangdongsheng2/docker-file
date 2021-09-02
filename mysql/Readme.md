#执行sql
show slave status；
#重点关注下列两个的状态[yes/no]：
Slave_IO_Running
Slave_SQL_Running

#主库
flush tables with read lock; #锁表
mysqldump -uroot -p‘root’  --all-databases > mysql.back.sql #备份,(手写复制容易出错)
scp -r /root/mysql.bask.sql root@node2:/tmp/ #拷贝到从库

#从库
mysql -uroot -p‘root’
stop slave;
reset slave;(可选)
source /mysql.back.sql ;
change master to master_host='192.168.130.70', master_user='slave', master_password='123456', master_port=3306, master_log_file='mysql-bin.000011', master_log_pos=151523, master_connect_retry=30;
start slave;
show slave status;
#主库
unlock tables;

#删除主从
stop slave;
reset slave all;
show slave status;

（主库执行-清除主库信息）
reset master;



