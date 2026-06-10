# Stage 1: Compilar
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends swi-prolog curl ca-certificates && rm -rf /var/lib/apt/lists/*
RUN which swipl && swipl --version
COPY --from=builder /app/target/*.jar app.jar
RUN mkdir -p /app/prolog && chmod 755 /app/prolog
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=docker"]
