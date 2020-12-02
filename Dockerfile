FROM adoptopenjdk/openjdk11:jdk-11.0.9_11.1-alpine-slim AS base

FROM base as builder

WORKDIR /project
COPY .mvn /project/.mvn
COPY mvnw /project/

COPY pom.xml /project/pom.xml

RUN ./mvnw de.qaware.maven:go-offline-maven-plugin:resolve-dependencies

COPY src /project/src
RUN ./mvnw package

FROM base as app

WORKDIR /app
EXPOSE 8080
CMD ["/bin/sh", "-c", "java $JAVA_OPTS -jar hello-world.jar"]

COPY --from=builder /project/target/spring-mvc-helloworld-0.0.1-SNAPSHOT.jar /app/hello-world.jar