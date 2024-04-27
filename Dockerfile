# Use a multi-stage build to leverage Gradle image for building
FROM gradle:latest as build

# Set the working directory inside the container
WORKDIR /home/gradle/project

# Copy only the build file(s) needed for dependency resolution
COPY build.gradle settings.gradle /home/gradle/project/

# Resolve dependencies first to take advantage of Docker cache
RUN gradle resolveDependencies --no-daemon

# Copy the entire project to the container
COPY . .

# Build the application
RUN gradle build --no-daemon

# Use a separate stage for the final image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /home/gradle/project/build/libs/*.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# Define the command to run the application
CMD ["java", "-jar", "app.jar"]
