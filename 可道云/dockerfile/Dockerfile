FROM centos:7
#----------Systemd integration start-------------------
#ENV container docker
#RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
#systemd-tmpfiles-setup.service ] || rm -f $i; done); \
#rm -f /lib/systemd/system/multi-user.target.wants/*;\
#rm -f /etc/systemd/system/*.wants/*;\
#rm -f /lib/systemd/system/local-fs.target.wants/*; \
#rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
#rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
#rm -f /lib/systemd/system/basic.target.wants/*;\
#rm -f /lib/systemd/system/anaconda.target.wants/*;
#VOLUME [ "/sys/fs/cgroup" ]
#------end--------------

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
yum -y install gcc gcc-c++ &&\
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&\
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm &&\
yum -y install yum-utils &&\
yum-config-manager --enable remi-php73 &&\
yum -y install php php-mcrypt php-devel php-cli php-gd php-pear php-curl php-fpm php-mysql php-ldap php-zip php-fileinfo &&\
yum -y install php-redis &&\
yum -y install php-mbstring &&\
yum install nginx -y &&\
yum clean all

ADD nginx.conf /etc/nginx/nginx.conf
#下载官方 zip 解压并打包成 tar.gz 包
ADD kdy.tar.gz /code
WORKDIR /code
RUN chmod 777 .
COPY init.sh /init.sh
EXPOSE 80
ENTRYPOINT ["/bin/bash","/init.sh"]


# sudo docker build --network=host  -t centos7_kod:v2 .
# sudo docker run -d -p 81:80  centos7_kod:v2