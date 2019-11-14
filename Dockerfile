FROM openjdk:8u121-jdk-alpine AS builder
WORKDIR /workspace/app

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src

RUN chmod +x ./mvnw &&./mvnw install -DskipTests &&mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM openjdk:8-jre-alpine
VOLUME /tmp
WORKDIR /app
COPY --from=builder /workspace/app/target/employees.jar /app/employees.jar
ENTRYPOINT ["java","-jar", "employees.jar"]