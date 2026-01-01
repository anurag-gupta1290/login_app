# ---------- BUILD ----------
FROM eclipse-temurin:17-jdk-focal AS builder
WORKDIR /app

COPY pom.xml .
RUN apt-get update && apt-get install -y maven && mvn dependency:go-offline

COPY . .
RUN mvn clean package -DskipTests

# ---------- RUN ----------
FROM eclipse-temurin:17-jre-focal
WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
