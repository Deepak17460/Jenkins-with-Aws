FROM openjdk:17
EXPOSE 8080
ADD target/basic-java-project-0.0.1-SNAPSHOT.jar /home.jar
ENTRYPOINT ["java", "-jar", "/home"]
