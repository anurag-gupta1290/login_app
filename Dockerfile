# ---------- BUILD ----------
FROM eclipse-temurin:17-jdk-focal AS builder
WORKDIR /app

# Copy only pom.xml first to cache dependencies
COPY pom.xml ./

# Install Maven and fetch dependencies offline
RUN apt-get update && \
    apt-get install -y maven && \
    mvn dependency:go-offline

# Copy the rest of the project
COPY . ./

# Build the app (skip tests for faster build)
RUN mvn clean package -DskipTests

# ---------- RUN ----------
FROM eclipse-temurin:17-jre-focal
WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port (you can override it with environment variable if needed)
EXPOSE 8080

# Use environment variables at runtime
ENV DATABASE_URL=""
ENV DATABASE_USERNAME=""
ENV DATABASE_PASSWORD=""
ENV EMAIL_USERNAME=""
ENV EMAIL_PASSWORD=""
ENV GOOGLE_CLIENT_ID=""
ENV FACEBOOK_CLIENT_ID=""
ENV FACEBOOK_CLIENT_SECRET=""
ENV GEMINI_API_KEY=""

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
