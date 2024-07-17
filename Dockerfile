FROM openjdk:17
EXPOSE 8080
ADD target/basic-java-project-0.0.1-SNAPSHOT.war /home.war
ENTRYPOINT ["java", "-jar", "/home.war"]
