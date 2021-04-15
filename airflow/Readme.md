#启动命令
```shell
#初始化文件夹
mkdir ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > .env
#初始化数据库等
docker-compose up airflow-init
#临时执行命令
docker-compose run airflow-worker airflow info
```



