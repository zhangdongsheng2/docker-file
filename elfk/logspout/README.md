# Logspout extension

Logspout 使用 Docker 日志 API 收集所有 Docker 日志，并将它们转发到 Logstash，无需任何额外配置。

1. [`官方仓库连接`](https://github.com/gliderlabs/logspout)
2. [`Logstash扩展仓库连接`](https://github.com/looplab/logspout-logstash)
3. build.sh 是Dockerfile编译镜像使用的脚本, 里面加了代理不加会很慢.
4. modules.go 扩展模块, 对接 Logstash. 
5. 如果需要给容器设置单独tag可以
   1. 设置环境变量: LOGSTASH_TAGS: "docker-elk,docker-elk-dypark"
   2. 这个环境变量可以用在日志过滤分流之中, 可以设置多个标签. 用逗号分割.
6. 对应不想收集日志的容器设置环境变量: LOGSPOUT: ignore
7. 在URL上设置包含哪些容器: 
   1. raw://192.168.10.10:5000?filter.name=*_db
   2. raw://192.168.10.10:5000?filter.id=3b6ba57db54a
   3. raw://192.168.10.10:5000?filter.sources=stdout%2Cstderr  #URL编码: stdout%2Cstderr  ==> stdout,stderr
   4. raw://192.168.10.10:5000?filter.labels=a:x*%2Cb:*y   #URL编码: a:x*%2Cb:*y ==> a:x*,b:*y
8. logspout-logstash 扩展模块的可用配置环境变量:

| Environment Variable | Input Type | Default Value |
|----------------------|------------|---------------|
| LOGSTASH_TAGS        | array      | None          |
| LOGSTASH_FIELDS      | map        | None          |
| INCLUDE_CONTAINERS   | array      | None          |
| DOCKER_LABELS        | any        | ""            |
| RETRY_STARTUP        | any        | ""            |
| RETRY_SEND           | any        | ""            |
| DECODE_JSON_LOGS     | bool       | true          |
| LOGSPOUT             |            |  ignore       |


## Usage

如果要包含 Logspout 扩展，请从存储库的根目录运行 Docker Compose，并使用引用 `logspout-compose.yml` 文件的附加命令行参数：


在您的 Logstash 管道配置中，启用 `udp` 输入并将输入编解码器设置为 `json`：
```logstash
input {
  udp {
    port  => 5000
    codec => json
  }
  tcp {
    port => 5000
    codec => json
  }
}
filter {
      json {
           source => "message"           
           skip_on_invalid_json => true   
           remove_field => ["message"]     
      }
}
output {
    if "docker-elk-cqpark" in [tags]{
        elasticsearch {
                hosts => "elasticsearch:9200"
                user => "elastic"
                password => "changeme"
                ecs_compatibility => disabled
                index => "tsl_cqpark_log-%{+YYYY_MM}"
        }
    }
	
	if "docker-elk-dypark" in [tags]{
		elasticsearch {
				hosts => "elasticsearch:9200"
				user => "elastic"
				password => "changeme"
				ecs_compatibility => disabled
				index => "tsl_dypark_log-%{+YYYY_MM}"
		}
	}
}

```

## Documentation

<https://github.com/looplab/logspout-logstash>
