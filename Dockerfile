# ========================
# 1. STAGE – Build JAR
# ========================
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

# Maven Wrapper
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw

# Copy pom and download deps first (cache boost)
COPY pom.xml .
RUN ./mvnw -q dependency:go-offline

# Copy source code
COPY src src

# Build Spring Boot app
RUN ./mvnw -q clean package -DskipTests


# ========================
# 2. STAGE – Slim JRE
# ========================
FROM eclipse-temurin:21-jdk AS jre-builder

RUN jlink \
    --add-modules java.base,java.logging,java.xml,java.naming,java.sql \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /javaruntime


# ========================
# 3. STAGE – Distroless runtime
# ========================
FROM gcr.io/distroless/base-debian12

WORKDIR /app

# Copy slim JRE
COPY --from=jre-builder /javaruntime /javaruntime

# Copy Spring Boot JAR
COPY --from=builder /app/target/*.jar /app/app.jar

ENV PATH="/javaruntime/bin:${PATH}"
EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
