# Multi-stage Docker build for Spring Boot application
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy Maven project configuration
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

# Copy source code and build jar
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Create upload directory
RUN mkdir -p /app/uploads && chmod 777 /app/uploads

# Copy built application jar
COPY --from=builder /app/target/*.jar app.jar

# Environment configuration
ENV PORT=8083
EXPOSE 8083

# Launch application
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -Dserver.port=${PORT:-8083} -jar app.jar"]
