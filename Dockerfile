# ===== STAGE 1: Build =====
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

# Кешируем зависимости
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B

# Копируем остальные файлы
COPY src src

# Собираем JAR
RUN ./mvnw clean package -DskipTests

# ===== STAGE 2: Runtime =====
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
