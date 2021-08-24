# 构建镜像，执行命令：【docker build -t twdt_io:2.0 .】
FROM openjdk:8u212-jre
MAINTAINER Mark
# 时区问题
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
RUN mkdir /home/uploader

ENTRYPOINT ["java", "-server", "-Djava.security.egd=file:/dev/./urandom", "-Dfile.encoding=UTF-8", "-XX:+HeapDumpOnOutOfMemoryError", "-jar", "/app/app.jar" ]


