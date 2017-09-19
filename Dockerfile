FROM webdizz/baseimage-java8:8u144

MAINTAINER Izzet Mustafaiev "izzet@mustafaiev.com"

ENV DEBIAN_FRONTEND noninteractive

ENV SONARQUBE_VERSION 6.2

RUN apt-get update && apt-get install -y unzip && apt-get clean \
    &&  curl --progress-bar -v -sLo sonarqube-${SONARQUBE_VERSION}.zip \
        https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip \
    && unzip sonarqube-${SONARQUBE_VERSION}.zip -d /tmp \
    && mv /tmp/sonarqube-${SONARQUBE_VERSION} /opt/sonar \
    && rm sonarqube-${SONARQUBE_VERSION}.zip \
    && apt-get remove -y --purge unzip \
    && apt-get autoremove -y gir1.2-glib-2.0 gsfonts libdbus-glib-1-2 libfontenc1 libfreetype6 libgirepository-1.0-1 libxfont1 python-pycurl python3-apt python3-dbus python3-gi python3-pycurl unattended-upgrades

RUN chmod 0666 /opt/sonar/conf/sonar.properties
RUN \
    sed -i s*#sonar.jdbc.url=jdbc:mysql://localhost:3306/.*$*sonar.jdbc.url=\${env:SONAR_JDBC_URL}*g /opt/sonar/conf/sonar.properties \
    &&  sed -i s*#sonar.jdbc.username.*$*sonar.jdbc.username=\${env:SONAR_DB_USERNAME}*g /opt/sonar/conf/sonar.properties \
    &&  sed -i s*#sonar.jdbc.password.*$*sonar.jdbc.password=\${env:SONAR_DB_PASSWORD}*g /opt/sonar/conf/sonar.properties

ENV SONAR_JDBC_URL jdbc:h2:tcp://localhost:9092/sonar
ENV SONAR_DB_USERNAME sonar
ENV SONAR_DB_PASSWORD sonar

EXPOSE 9000

CMD /opt/sonar/bin/linux-x86-64/sonar.sh console
