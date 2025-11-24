FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar
ENV JAVA_OPTS="-Xmx512m -Xms256m"
# Исполнение без оболочки, чтобы переменные правильно подставлялись
ENTRYPOINT ["java", "-Xmx512m", "-Xms256m", "-jar", "app.jar"]