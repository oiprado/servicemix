FROM java:8-jdk
MAINTAINER oiprado@gmail.com
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV SERVICEMIX_VERSION_MAJOR=7
ENV SERVICEMIX_VERSION_MINOR=0
ENV SERVICEMIX_VERSION_PATCH=1
ENV SERVICEMIX_VERSION=${SERVICEMIX_VERSION_MAJOR}.${SERVICEMIX_VERSION_MINOR}.${SERVICEMIX_VERSION_PATCH}

ENV FTP_SERVER_VERSION_MAJOR=1
ENV FTP_SERVER_VERSION_MINOR=1
ENV FTP_SERVER_VERSION_PATCH=1
ENV FTP_SERVER_VERSION=${FTP_SERVER_VERSION_MAJOR}.${FTP_SERVER_VERSION_MINOR}.${FTP_SERVER_VERSION_PATCH}

#download the Apache FTP server & extract
RUN wget http://www-us.apache.org/dist/mina/ftpserver/${FTP_SERVER_VERSION}/dist/apache-ftpserver-${FTP_SERVER_VERSION}.zip; \
    unzip -d /opt apache-ftpserver-${FTP_SERVER_VERSION}.zip; \
    rm -f apache-ftpserver-${FTP_SERVER_VERSION}.zip; \
    ln -s /opt/apache-ftpserver-${FTP_SERVER_VERSION} /opt/ftpserver; \

#WORKDIR "/apache-ftpserver-${FTP_SERVER_VERSION}"

#ADD ftpd.xml ftpd.xml

RUN wget http://www-us.apache.org/dist/servicemix/servicemix-${SERVICEMIX_VERSION_MAJOR}/${SERVICEMIX_VERSION}/apache-servicemix-${SERVICEMIX_VERSION}.zip; \
    unzip -d /opt apache-servicemix-${SERVICEMIX_VERSION}.zip; \
    rm -f apache-servicemix-${SERVICEMIX_VERSION}.zip; \
    ln -s /opt/apache-servicemix-${SERVICEMIX_VERSION} /opt/servicemix; \
    mkdir /deploy; \
    sed -i 's/^\(felix\.fileinstall\.dir\s*=\s*\).*$/\1\/deploy/' /opt/servicemix/etc/org.apache.felix.fileinstall-deploy.cfg; \
    sed '$d' /opt/servicemix/etc/users.properties; \
    echo 'admin = admin, clave,_g_:admingroup' >> /opt/servicemix/etc/users.properties
VOLUME ["/deploy"]
EXPOSE 1099 8101 8181 61616 44444
ENTRYPOINT ["/opt/servicemix/bin/servicemix"]


