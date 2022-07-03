# 构建镜像，执行命令：【docker build -t tsl_jdk8_512:2.0 .】
FROM openjdk:8u212-jre
MAINTAINER Mark
# 时区问题
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
RUN mkdir /home/uploader

#https://github.com/vishnubob/wait-for-it/blob/master/wait-for-it.sh
COPY wait-for-it.sh /usr/local/bin/
RUN ln -s /usr/local/bin/wait-for-it.sh /usr/bin/wait-for-it.sh

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]



