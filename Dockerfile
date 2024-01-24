#FROM mangeshabnave/spring-maven as build 
#WORKDIR /code
#COPY . . 
#RUN mvn package 


FROM openjdk:19-ea-jdk-alpine3.16
WORKDIR /
COPY target/spring-petclinic-*.jar app
EXPOSE 8080 
CMD java -jar app 
