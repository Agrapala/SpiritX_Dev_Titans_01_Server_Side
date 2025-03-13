# Build stage
FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app

# Copy pom.xml first for better caching
COPY pom.xml .
# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application (skip tests)
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-slim

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"] 