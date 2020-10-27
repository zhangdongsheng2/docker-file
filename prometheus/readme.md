
##1.   创建文件夹
````shell script
mkdir -p /opt/docker/prometheus/{prometheus,prometheus/data,alertmanager,grafana}
chmod 777 /opt/docker/prometheus/{prometheus/data,grafana}
cd /opt/docker/prometheus
````
*  目录结构   
tree .
```shell script
├── alertmanager
│   ├── alertmanager.yml
│   └── config.yml
├── docker-compose.yml
├── grafana
└── prometheus
    ├── alert-rules.yml
    ├── data
    └── prometheus.yml
4 directories, 5 files
```
## 2.  编辑文件
```shell script
vim  /opt/docker/prometheus/prometheus/alert-rules.yml
vim  /opt/docker/prometheus/prometheus/prometheus.yml
vim  /opt/docker/prometheus/alertmanager/config.yml
vim  /opt/docker/prometheus/alertmanager/alertmanager.yml
vim  /opt/docker/prometheus/docker-compose.yml
```

## 3. 执行命令
```shell script
sudo docker-compose up -d
```
 



















