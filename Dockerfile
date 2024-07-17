FROM tomcat:10.1-jdk17-openjdk
EXPOSE 8080
#ADD target/basic-java-project-0.0.1-SNAPSHOT.war /home.war
ADD target/basic-java-project-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/home.war
#ENTRYPOINT ["java", "-jar", "/home.war"]
