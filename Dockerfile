FROM centos:7

LABEL maintainer="KAI VO"

RUN yum update -y
# Install sshd
RUN yum install openssh-server -y && \
	ssh-keygen -A && \
	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "root:123456" | chpasswd
# Install packages build jconnector and tomcat	
RUN yum install httpd -y && \
    yum install wget openssh-server httpd-devel apr apr-devel apr-util apr-util-devel gcc* gcc-c++ make autoconf libtool python-setuptools easy_install supervisor java-11-openjdk java-11-openjdk-devel curl -y

COPY source/http/conf /etc/httpd/conf
COPY source/http/conf.d /etc/httpd/conf.d
COPY source/apache-tomcat-9.0.30.tar.gz /opt/
COPY source/tomcat-connectors-1.2.46-src.tar.gz /opt/

RUN cd /opt/ \
&& tar -zxvf tomcat-connectors-1.2.46-src.tar.gz \
&& cd /opt/tomcat-connectors-1.2.46-src/native \
&& ./configure --with-apxs=/usr/bin/apxs \
&& make \
&& make install


RUN cd /opt/ \
&& tar -zxvf apache-tomcat-9.0.30.tar.gz \
&& mkdir /opt/tomcat9 \
&& cd apache-tomcat-9.0.30 \
&& cp -R * /opt/tomcat9/ \
&& chmod -R 777 /opt/tomcat9

# remove file taz
RUN rm -rf /opt/apache-tomcat-9.0.30.tar.gz && \
    rm -rf /opt/tomcat-connectors-1.2.46-src.tar.gz

# Install service supervisor
RUN yum install -y python-setuptools && \
    easy_install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d 

COPY supervisor.conf /etc/supervisor.conf
COPY start.sh /opt/

# add mod execute file bash shell
RUN chmod +x /opt/start.sh
	
EXPOSE 80 22 8080
CMD ["supervisord", "-c", "/etc/supervisor.conf"]