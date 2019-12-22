FROM ubuntu:18.04

MAINTAINER WDG
### Stage 1 - Installing dependencies and updating distro
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get -y install software-properties-common && \
        add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get -y update && apt-get -y install \
        openjdk-8-jdk \
        git \
        ant \
        wget\
        vim
### Stage 2 - Tomcat Setup & Conifguration
#Tomcat Config
RUN mkdir /opt/tomcat
RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN wget http://apache.mirror.anlx.net/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz \
    -O /tmp/apache-tomcat-8.5.50.tar.gz
RUN tar xvf /tmp/apache-tomcat-8.5.50.tar.gz -C /opt/tomcat --strip-components=1
RUN rm -f /tmp/apache-tomcat-8.5.50.tar.gz
RUN chmod +x /opt/tomcat/bin/*.sh

#BimServer Setup
RUN mkdir     /opt/tomcat/conf/policy.d
RUN mkdir     /opt/tomcat/webapps/ROOT/WEB-INF/classes
#RUN mkdir -p  /var/www/bimserver
RUN mkdir -p  /var/bimserver/home
#RUN chown -R tomcat /var/www/bimserver
RUN chown -R tomcat /var/bimserver/*

### Stage 3 - Environment Setup Configuration
RUN chgrp -R tomcat /opt/tomcat/conf
RUN chmod g+rwx /opt/tomcat/conf && chmod g+r /opt/tomcat/conf/*
#RUN chmod g+r /opt/tomcat/conf/*
RUN chown -R tomcat /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/ && chown -R tomcat /opt && chown -R tomcat /opt/tomcat/webapps
#RUN chown -R tomcat /opt && chown -R tomcat /opt/tomcat/webapps
RUN chmod a+rwx /opt && chmod a+rwx /opt/tomcat/webapps

# Stage 4 Set Environment paths for Tomcat
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV CATALINA_HOME=/opt/tomcat
ENV JAVA_OPTS="-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

#Stage 6 BIMServer WAR file moving to webapps
COPY target/BIMserver.war  /opt/tomcat/webapps
COPY scripts/default.policy /opt/tomcat/conf/default.policy
COPY scripts/server.xml /opt/tomcat/conf/server.xml
COPY scripts/Bimsql.properties /opt/tomcat/conf/
COPY scripts/setenv.sh   /opt/tomcat/bin/

RUN chown -R tomcat /opt/tomcat/webapps
RUN chown -R tomcat /opt/tomcat/conf/*
#RUN chmod a+rwx  /var/www/bimserver
RUN chmod a+rwx  /var/bimserver/*
##################### INSTALLATION END #####################
USER tomcat
EXPOSE 8080

CMD /opt/tomcat/bin/catalina.sh run

VOLUME  /opt/tomcat
VOLUME /var/bimserver/home



