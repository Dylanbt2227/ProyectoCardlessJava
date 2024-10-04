FROM openjdk:17-jdk-slim AS build

# Definir el directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml y descargar las dependencias
COPY pom.xml .
COPY src ./src
RUN ./mvnw dependency:go-offline

# Construir el proyecto
RUN ./mvnw package -DskipTests

# Etapa de ejecución
FROM openjdk:17-jdk-slim

# Copiar el archivo JAR desde la etapa de construcción
COPY --from=build /app/target/CajerosCardless-0.0.1-SNAPSHOT.jar app.jar

# Configurar el puerto que la aplicación va a usar
ENV PORT 8080
EXPOSE $PORT

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "/app.jar"]