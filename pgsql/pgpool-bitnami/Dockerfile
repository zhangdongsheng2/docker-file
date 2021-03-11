FROM bitnami/pgpool:latest

USER root
COPY sources.list /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y vim \
    && apt-get install -y openssh-server
# postgres用户ssh免密
RUN mkdir -p /root/.ssh/

COPY id_rsa  /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub
COPY sshd_config /etc/ssh/sshd_config

RUN chmod 600 /root/.ssh/id_rsa

# 将failover_command设置为evn变量
COPY libpgpool.sh /opt/bitnami/scripts/libpgpool.sh
RUN chmod 777 /opt/bitnami/scripts/libpgpool.sh

# 配置failover脚本（主节点下线从节点升为主节点）
COPY failover.sh /usr/local/etc/failover.sh
RUN chmod 777 /usr/local/etc/failover.sh

RUN mkdir /run/sshd

CMD /etc/init.d/ssh start && /opt/bitnami/scripts/pgpool/run.sh