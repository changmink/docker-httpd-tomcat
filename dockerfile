FROM centos:centos6

RUN adduser irteam

# wget
RUN yum -y install wget

# JAVA
RUN yum -y install java-1.8.0-openjdk

# TOMCAT
RUN wget -P /home/irteam/ http://apache.tt.co.kr/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz
RUN tar -xvzf /home/irteam/apache-tomcat-7.0.92.tar.gz -C /home/irteam
WORKDIR /home/irteam
RUN ln -s apache-tomcat-7.0.92 tomcat

# HTTPD & Tomcat Connector
RUN yum -y install httpd-devel apr apr-devel apr-util apr-util-devel gcc gcc-c++ make autoconf libtool
RUN /etc/init.d/httpd stop
RUN wget -P /home/irteam http://mirror.navercorp.com/apache/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.46-src.tar.gz
RUN tar -xvzf /home/irteam/tomcat-connectors-1.2.46-src.tar.gz -C /home/irteam
WORKDIR /home/irteam/tomcat-connectors-1.2.46-src/native
RUN /home/irteam/tomcat-connectors-1.2.46-src/native/configure --with-apxs=/usr/sbin/apxs
RUN make
RUN libtool --finish /usr/lib64/httpd/modules
RUN make install
RUN chmod 755 /usr/lib64/httpd/modules/mod_jk.so

RUN mkdir -p /var/run/mod_jk
RUN chown apache:apache /var/run/mod_jk

# SETTING
COPY mod_jk.conf /etc/httpd/conf.d/mod_jk.conf
COPY workers.properties /etc/httpd/conf/workers.properties
RUN mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.temp

## deploy
WORKDIR /home/irteam/tomcat
RUN rm -rf /home/irteam/tomcat/webapps
ADD ./target/*.war /home/irteam/tomcat/webapps/
ADD server.xml ./conf

# Start server
EXPOSE 8080 80

WORKDIR /home/irteam/
ADD run.sh /home/irteam
RUN chmod +x run.sh
CMD ./run.sh