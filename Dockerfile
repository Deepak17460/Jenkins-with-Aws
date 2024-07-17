FROM tomcat:10.1-jdk17-openjdk
EXPOSE 8080
ARG ARTIFACTORY_USERNAME
ARG ARTIFACTORY_PASSWORD
RUN curl -fL -u $ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD -o /usr/local/tomcat/webapps/basic-java-project.war "http://192.168.56.102:8082/artifactory/java-nagarro-assignment/binaryWar/basic-java-project-0.0.1-SNAPSHOT.war"
