FROM webdizz/baseimage-java8:latest

MAINTAINER Izzet Mustafaiev "izzet@mustafaiev.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y unzip && apt-get clean

ENV SONARQUBE_VERSION 5.0.1
RUN curl -sLo sonarqube-${SONARQUBE_VERSION}.zip http://dist.sonar.codehaus.org/sonarqube-${SONARQUBE_VERSION}.zip && \
    unzip sonarqube-${SONARQUBE_VERSION}.zip -d /tmp && \
    mv /tmp/sonarqube-${SONARQUBE_VERSION} /opt/sonar && \
    rm sonarqube-${SONARQUBE_VERSION}.zip

RUN sed -i s*#sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar*sonar.jdbc.url=\${env:SONAR_JDBC_URL}*g /opt/sonar/conf/sonar.properties && \
    sed -i s*#sonar.jdbc.username=sonar*sonar.jdbc.username=\${env:SONAR_DB_USERNAME}*g /opt/sonar/conf/sonar.properties && \
    sed -i s*#sonar.jdbc.password=sonar*sonar.jdbc.password=\${env:SONAR_DB_PASSWORD}*g /opt/sonar/conf/sonar.properties

ENV SONAR_JDBC_URL jdbc:h2:tcp://localhost:9092/sonar
ENV SONAR_DB_USERNAME sonar
ENV SONAR_DB_PASSWORD sonar

EXPOSE 9000

CMD /opt/sonar/bin/linux-x86-64/sonar.sh console
