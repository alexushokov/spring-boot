FROM gradle:latest as build
COPY . .
RUN ./gradlew build

FROM openjdk:17-jdk-slim
COPY --from=build /build/libs/spring.jar spring.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","spring.jar"]