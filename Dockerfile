# Multi-stage Docker build for Spring Boot application
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy Maven project files
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

# Render assigns a dynamic port via PORT environment variable (defaults to 10000)
ENV PORT=10000
EXPOSE 10000

# Launch application with dynamic PORT binding
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -Dserver.port=${PORT:-10000} -jar app.jar"]
