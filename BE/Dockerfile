# Use the latest Maven image with OpenJDK 21 as the base image for building the application
FROM maven:3.8.7-openjdk-18-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and any other necessary files for dependencies
COPY pom.xml .

# Download the dependencies for offline use
RUN mvn dependency:go-offline

# Copy the source code into the container
COPY src ./src

# Package the application
RUN mvn clean package

# Use the latest OpenJDK image for running the application
FROM openjdk:18-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged application from the build stage
COPY --from=build /app/target/spring-boot-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port the application will run on
EXPOSE 8080

# Set the entry point to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
